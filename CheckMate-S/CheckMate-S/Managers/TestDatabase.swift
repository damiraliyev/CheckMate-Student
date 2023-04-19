//
//  TestDatabase.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 15.03.2023.
//

import Foundation



// Step 1: Query the subject ID
let subjectQuery = DatabaseManager.shared.database.collection("subjects").whereField("code", isEqualTo: "CSS342")

class DB {
    func attendanceCourseStudentIDValue() {
        //Setting CSS358[01-N]
//        let data1 = [
//            "15.05.2023" : [
//                ["200107116": "0/1"],
//                ["200107055": "0/1"],
//                ["200107085": "0/1"],
//                ["200107094": "0/1"],
//                ["200107092": "0/1"],
//                ["200107038": "0/1"],
//                ["200107044": "0/1"],
//                ["200107005": "0/1"],
//                ["200107027": "0/1"],
//            ]
//        ]
//        let ref = DatabaseManager.shared.database.collection("attendance").document("CSS358[01-N]").setData(data1, merge: true)
//
        
        //CSS342[07-P]
        
//        let data2 = [
//            "16.05.2023" : [
//                ["200107116": "0/1"],
//                ["200107055": "0/1"],
//                ["200107085": "0/1"],
//                ["200107094": "0/1"],
//                ["200107092": "0/1"],
//                ["200107038": "0/1"],
//                ["200107044": "0/1"],
//                ["200107005": "0/1"],
//                ["200107027": "0/1"],
//            ]
//        ]
//let ref = DatabaseManager.shared.database.collection("attendance").document("CSS342[07-P]").setData(data2, merge: true)
        
//        let data3 = [
//                    "15.05.2023" : [
//                        ["200107116": "0/1"],
//                        ["200107055": "0/1"],
//                        ["200107085": "0/1"],
//                        ["200107094": "0/1"],
//                        ["200107092": "0/1"],
//                        ["200107038": "0/1"],
//                        ["200107044": "0/1"],
//                        ["200107005": "0/1"],
//                        ["200107027": "0/1"],
//                    ]
//                ]
//        let ref = DatabaseManager.shared.database.collection("attendance").document("CSS342[01-N]").setData(data3, merge: true)

        
        let attendanceData = [
                    "10.04.2023": [
                        [
                            "200107116" : [true],
                            "200107055" : [true],
                            "200107111" : [true],
                            "200107117" : [true],
                            "200107191" : [true],
                            "200107101" : [true],
                            "200107110" : [true],
                        ],
                        
                    ],
                    
                
                    
                ]

//                let ref = DatabaseManager.shared.database.collection("attendance").document("CSS342[01-P]").setData(attendanceData, merge: true)
        
    }
    
    func addTokens() {
        let tokens = [
            "tokens": ["10.04.2023": ["random", "random2"]]
            ]
//        let ref = DatabaseManager.shared.database.collection("attendance").document("CSS342[01-N]").setData(tokens, merge: true)

    }
}

func testQuery() {
    subjectQuery.getDocuments() { (subjectSnapshot, error) in
        if let error = error {
            print("Error querying subject: \(error)")
            return
        }
        print("WITHOUT ERROR QUERYING SUBJECT!!!!!!")
        guard let subjectDoc = subjectSnapshot?.documents.first else {
            print("No matching subject found")
            return
        }

        let subjectID = subjectDoc.documentID
        
        // Step 2: Query the EnrolledStudents subcollection
        let enrolledStudentsQuery = DatabaseManager.shared.database.collection("subjects/\(subjectID)/enrollments")
        enrolledStudentsQuery.getDocuments() { (enrolledStudentsSnapshot, error) in
            if let error = error {
                print("Error querying enrolled students: \(error)")
                return
            }
            
            // Step 3: For each document in the EnrolledStudents subcollection, query the attendance field for the specified date
            for enrolledStudentDoc in enrolledStudentsSnapshot!.documents {
                let studentID = enrolledStudentDoc.documentID
                
                let attendance = enrolledStudentDoc.get("attendance") as? [String:Any]
                if let attendance = attendance {
                    if let recordDate = attendance["date"] as? String, recordDate == "15.03.2023",
                       let status = attendance["status"] as? String {
                        print("Student \(studentID) attended on 15.03.2023 with status: \(status)")
                    }
                }

            }
        }
    }

}


