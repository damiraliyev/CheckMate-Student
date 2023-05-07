//
//  DatabaseManager.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 09.03.2023.
//

import FirebaseFirestore
import Foundation
//import OrderedCollections

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    func findUser(with email: String, completion: @escaping (String, String) -> Void) {
        let ref = database.collection("students").whereField("email", isEqualTo: email)
        
        
        ref.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("SNAPSHOT WASN'T FOUND")
                return
            }
            
            let name = snapshot.documents.first?.get("name") as? String ?? ""
            let surname = snapshot.documents.first?.get("surname") as? String ?? ""
            
            completion(name, surname)
        }
        
    }
    
    func queryAmountOfClasses(subjectCode code: String, completion: @escaping (Int) -> ()) {
        let fullname = (UserDefaults.standard.value(forKey: "name") as? String ?? "") + " " +  (UserDefaults.standard.value(forKey: "surname") as? String ?? "")
        let docID = DatabaseManager.shared.database.collection("students").document(fullname)
        var totalAttendanceCount = 0
        var amountOfHours = 0
        docID.getDocument {snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            let studentID = snapshot.get("id") as? String ?? ""
            
            let ref = DatabaseManager.shared.database.collection("subjects")
                .whereField("code", isGreaterThan: "\(code)")
                .whereField("code", isLessThan: "\(code)u{f8ff}]")
                .whereField("enrolledStudents", arrayContains: studentID)
            ref.getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("queryAmountOfClasses: \(error)")
                    return
                }
                
                for doc in snapshot.documents {
                    print("DOOOC", doc.data())
                    var temp = 0
                    
                    
                    let startTime = (doc.get("startTime") as? String ?? "")
                    let endTime = (doc.get("endTime") as? String ?? "")
                    
                    let startHour = Int(String(startTime.prefix(2))) ?? 0
                    let endHour = Int(String(endTime.prefix(2))) ?? 0
                    
                    amountOfHours = endHour - startHour
                    if amountOfHours + 1 == 2 {
                        totalAttendanceCount += (((doc.get("dates") as? [String])?.count ?? 15) * 2)
                    } else {
                        totalAttendanceCount += ((doc.get("dates") as? [String])?.count ?? 15)
                    }
//                    totalAttendanceCount *= (amountOfHours + 1)
                }
                completion(totalAttendanceCount)
                totalAttendanceCount = 0
            }
        }
    }
    
    func querySubjects(name: String, surname: String, completion: @escaping ([Subject]) -> Void) {
        var subjects: [Subject] = []
        let docID = DatabaseManager.shared.database.collection("students").document("\(name) \(surname)")
        let dispatchGroup = DispatchGroup()
        
        docID.getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            guard let studentID = snapshot.get("id") else { return }
            
            
            DatabaseManager.shared.database.collection("subjects")
                .whereField("enrolledStudents", arrayContains: studentID)
                .order(by: "id")
                .getDocuments  { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let code = document.get("code") as? String ?? ""
                            let name = document.get("name") as? String ?? ""
                            
                            dispatchGroup.enter()
                            self?.queryAmountOfClasses(subjectCode: String(code.prefix(6))) { total in
                                self?.queryAttendance(
                                    name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                                    surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                                    for: String(code.prefix(6)),
                                    completion: { presence, absence in
                                        guard let contains = self?.checkIfContains(subjects: subjects,name: name) else { return }
                                    
                                    if !contains {
                                        subjects.append(
                                            Subject(
                                                subjectCode: code,
                                                subjectName: name,
                                                totalAttendanceCount: total,
                                                presenceCount: presence,
                                                absenceCount: absence)
                                        )
                                        subjects.sort(by: { s1, s2 in
                                            s1.subjectCode < s2.subjectCode
                                        })
                                    }
                                    dispatchGroup.leave()
                                })
                            }
                        }
                        dispatchGroup.notify(queue: .main) { // Call the completion block when all tasks have finished
                            print("Why there is 2 software engineerings?", subjects)
                            completion(subjects)
                        }
                    }
                }
        }
        
    }
    
    
    func queryAttendance(name: String, surname: String, for subject: String, completion: @escaping (_ presenceCount: Int, _ absenceCount: Int) -> Void) {
        let docID = DatabaseManager.shared.database.collection("students")
            .document("\(name) \(surname)")
        var presenceCount = 0
        var absenceCount = 0

        docID
            .getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }

            guard let studentID = snapshot.get("id") else {
                return
            }
                
            DatabaseManager.shared.database.collection("attendance")
                .whereField("code", isGreaterThanOrEqualTo: subject)
                .whereField("code", isLessThan: "\(subject)u{f8ff}]")
                .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error: \(error)")
                    return
                }

                for document in snapshot.documents {
                    let dates = document.data().keys //dates 15.03.2023...
                    for key in dates {
                        let value = document.data()[key] // returns array

                        if let arr = value as? [Any]{
                            if let dict = arr[0] as? [String: Any] {
                                guard let attendances = dict["\(studentID)"] as? [Int] else { continue }
                                for attendance in attendances {
                                    if(attendance == 0) {
                                        absenceCount += 1;
                                    } else {
                                        presenceCount += 1
                                    }
                                }
                                

                            } else {
                                print("Could not cast to [String: Any]")
                            }
                        } else {
                            print("Could not cast to [Any]")
                        }
                    }
                }
                    completion(presenceCount, absenceCount)
            }

        }
    }
    
    
    func checkIfContains(subjects: [Subject], name: String) -> Bool {
        var contains = false
        
        for i in 0..<subjects.count {
            if subjects[i].subjectName == name {
                contains = true
            }
        }
        
        return contains
    }
//    
    func loadAttendance(completion: @escaping ([Subject]) -> Void) {
        let docRef = DatabaseManager.shared.database.collection("attendance")
        
        docRef.getDocuments {[weak self] snapshot, error in
                guard let _ = snapshot, error == nil else {
                    return
                }
                
                DatabaseManager.shared.querySubjects(
                    name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                    surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "") { subjects in
                        print("Why there is 2 software engineerings in completion")
                        completion(subjects)
                    }
            }
        
    }
    
    func loadAttendanceStatusForParticularDate(dataString: String, fullCode: String, completion: @escaping ( [String: Any] ) -> Void) {
        let documentReference = DatabaseManager.shared.database.collection("attendance").document(fullCode)
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let attendance = data?[dataString] as? [[String: Any]] {
                    let studentID = UserDefaults.standard.value(forKey: "id") as? String ?? ""
                    let attStatus = attendance[0][studentID] as! [Int]
                    var attended: [Int] = []
                    for attendance in attStatus {
                        if attendance == 1 {
                            attended.append(1)
                        } else {
                            attended.append(0)
                        }
                    }
                    let dict = [
                        "needToAttend": attStatus.count,
                        "attended": attended
                    ]
                    completion(dict)
                } else {
                    print("Unfortunately, it goes to else block")
                    completion([:])
                }
                
            } else {
                completion([:])
                print("Document does not exist")
            }
        }
        
    }
    
    func getAbsenceClassesForSubject(shortSubjectCode: String, completion: @escaping ([String], [String]) -> Void) {
        let docRef = DatabaseManager.shared.database.collection("attendance")
            .whereField("code", isGreaterThanOrEqualTo: shortSubjectCode)
            .whereField("code", isLessThan: "\(shortSubjectCode)u{f8ff}]")

        let studID = UserDefaults.standard.value(forKey: "id") as? String ?? ""
        var absenceDict: [String: [Int]] = [:]
        var absenceDates: [String] = []
//        var statuse:
        
        var times: [String] = []
        getDates(shortSubjectCode: shortSubjectCode) { dates, time in
            guard let dates = dates else {
                completion([], [])
                return
            }
            
            docRef.getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    completion([], [])
                    return
                }
  
                for doc in snapshot.documents {
                    let data = doc.data()
                    for date in dates {
                        if let dateInfo = data[date] as? [[String: [Int]]] {
                            if let statuses = dateInfo[0][studID] {
                                var counter = 0
                                for status in statuses {
                                    if status == 0 {
                                        absenceDates.append(date)
                                        print("adding absence", absenceDict[date])
                                        if counter > 0 {
                                            let startHour = (Int((data["startTime"] as? String ?? ":").prefix(2)) ?? 0) + 1
                                            print("startHour", startHour)
                                            let time = String(startHour) + ":00"
                                            print("Incremented time", time)
                                            times.append(time)
                                            
                                        } else {
                                            times.append(data["startTime"] as? String ?? ":")
                                        }
                                        
                                        
                                        print("adding absence time", times)
                                    }
                                    counter += 1
                                    
                                }
                            
//                                absenceDict[date] = statuses
                            }
                        }
                    }
                    
//                    time = data["code"] as? String ?? "QWE"

                }
                print("Absence dict", absenceDates)
                print("times", times)
                completion(absenceDates, times)
            }
            
        }
       
        
       
    }
    
    func getDates(shortSubjectCode: String, completion: @escaping ([String]?, [String]?) -> Void) {
        let studID = UserDefaults.standard.value(forKey: "id") as? String ?? ""
        
        var dates: [String] = []
        var times: [String] = []
        let docRef = DatabaseManager.shared.database.collection("subjects")
            .whereField("code", isGreaterThanOrEqualTo: shortSubjectCode)
            .whereField("code", isLessThan: "\(shortSubjectCode)u{f8ff}]")
            .whereField("enrolledStudents", arrayContains: studID)
    
        docRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error when fetching dates")
                completion(nil, nil)
                return
            }
            
            print("DOCUMENT LENGTH", snapshot.documents.count)
            
            for doc in snapshot.documents {
                if let data = doc.data()["dates"] as? [String], let startTime = doc.data()["startTime"] as? String{
                    for date in data {
                        dates.append(date)
                        times.append(startTime)
                    }
                }
//                time = doc.data()["startTime"] as? String ?? ""
            }
            completion(dates, times)
        }
        
    }
    
    
    
    func getTokens(for date: String, fullCode: String, completion: @escaping ([String]?) -> Void) {
        let documentReference = DatabaseManager.shared.database.collection("attendance").document(fullCode)
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let tokens = data?["tokens"] as? [String: Any] {
//                    let studentID = UserDefaults.standard.value(forKey: "id") as? String ?? ""
                    let tokensForDate = tokens[date] as? [String]
                    
                    completion(tokensForDate)
                } else {
                    print("Unfortunately, it goes to else block")
                    completion(nil)
                }
                
            } else {
                completion(nil)
                print("Document does not exist")
            }
        }
    }
    
    func updateAttendanceStatus(
        date: String,
        studentID: String,
        fullSubjectCode: String,
        index: Int,
        completion: @escaping (Bool) -> Void) {
        let docRef = DatabaseManager.shared.database.collection("attendance").document(fullSubjectCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var attendanceData = document.data() ?? [:]
                if var dataForDate = attendanceData[date] as? [[String: Any]], var studentData = dataForDate.first(where: { $0[studentID] != nil }) {
                    guard var attStatusesOfStudent = studentData[studentID] as? [Bool] else {
                        completion(false)
                        return
                    }
               
                    attStatusesOfStudent[index] = true // update the value here
                    studentData[studentID] = attStatusesOfStudent
                    print("attStatusesOfStudent \(attStatusesOfStudent)")
                    dataForDate = [studentData]
                    attendanceData[date] = dataForDate
                    docRef.setData(attendanceData, merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            completion(false)
                        } else {
                            print("Document successfully updated")
                            completion(true)
                        }
                    }
                }
            } else {
                print("Document does not exist")
                completion(false)
            }
        }

    }
    
    func sendMessage(
        fullSubjectCode: String,
        dict: [String: Any],
        completion: @escaping (Bool) -> Void) {
            print("SEND MESSAGE DICT: ", dict)
            DatabaseManager.shared.database
                .collection("message")
                .document(fullSubjectCode).setData(dict as [String : Any], merge: true) { error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
        }
    
    func getAllMessages(completion: @escaping ([[String: String]]?) -> Void) {
        let fullName = (UserDefaults.standard.value(forKey: "name") as? String ?? "") + " " + (UserDefaults.standard.value(forKey: "surname") as? String ?? "")
        var resultInfo: [[String: String]] = []
        
        database.collection("message")
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error when fetching messages")
                    print(fullName)
                    return
                }
                
                for document in snapshot.documents {
                    for (key, _) in document.data() {
                        guard var messageData = document.data()[key] as? [String: String] else {
                            print("Couldn't cast as [String: String] message")
                            completion(nil)
                            return
                        }
                        
                        if messageData["sender"] == fullName {
                            messageData["classDate"]  = key
                            print("MESSAGE DATA", messageData)
                            resultInfo.append(messageData)
                        }
                    }
                    
                }
                completion(resultInfo)

            }
    }
    
    func deleteMessage(fullSubjectCode: String, date: String, completion: @escaping () -> Void) {
        let docRef = database.collection("message").document(fullSubjectCode)
        docRef.setData([date: FieldValue.delete()], merge: true) { error in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                } else {
                    print("Document deleted successfully.")
                    completion()
                }
            
            
        }
        
    }
    
}

