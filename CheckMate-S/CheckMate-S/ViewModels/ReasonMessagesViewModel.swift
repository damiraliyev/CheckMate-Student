//
//  AbsenceReasonViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import Foundation

class ReasonMessagesViewModel {
    
    var messages: [Message] = [
       
    ]
    
    var messagesDidChange: (() -> Void)?
    
    func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived), name: NSNotification.Name("message"), object: nil)
    }
    
    func fetchMessages(completion: @escaping () -> Void) {
        DatabaseManager.shared.getAllMessages { [weak self] resultInfo in
            guard let resultInfo = resultInfo else {
                completion()
                return
            }
            
            for info in resultInfo {
                let subject = info["subject"] ?? ""
                let sentTime = info["sentTime"] ?? ""
                let messageBody = info["message"] ?? ""
                let sentDate = info["sentDate"] ?? ""
                let teacherID = info["to"] ?? ""
                let classDate = info["classDate"] ?? ""
                print("TEACHER ID", teacherID)
                let message = Message(
                    sender: "",
                    senderID: "",
                    forSubject: subject,
                    body: messageBody,
                    classTime: "",
                    sentTime: sentTime,
                    sentDate: sentDate,
                    teacherID: teacherID,
                    absenceDate: classDate
                )
                self?.messages.append(message)
                
            }
            self?.messages.sort {
                if $0.sentDate == $1.sentDate {
                    return $0.sentTime < $1.sentTime
                } else {
                    return $0.sentDate < $1.sentDate
                }
            }
            completion()
        }
    }
    
    
    @objc func messageReceived(_ notification: Notification) {
        guard let messageInfo = notification.userInfo else {
            return
        }
        
        var messageBody = ""
        var subject = ""
        var classTime = ""
        var sentTime = ""
        var sender = ""
        var sentDate = ""
        var teacherID = ""
        var classDate = ""
        print("Message info", messageInfo)
        
        for (key, _) in messageInfo {
            print("IN for loop", key)
            messageBody = (messageInfo[key] as? [String: Any])?["message"] as? String ?? ""
            subject = (messageInfo[key] as? [String: Any])?["subject"] as? String ?? ""
            classTime = (messageInfo[key] as? [String: Any])?["classTime"] as? String ?? ""
            sentTime = (messageInfo[key] as? [String: Any])?["sentTime"] as? String ?? ""
            sender = (messageInfo[key] as? [String: Any])?["sender"] as? String ?? ""
            sentDate = (messageInfo[key] as? [String: Any])?["sentDate"] as? String ?? ""
            teacherID = (messageInfo[key] as? [String: Any])?["to"] as? String ?? ""
            classDate = (messageInfo[key] as? [String: Any])?["classDate"] as? String ?? ""
        }
        
        
        
        let message = Message(sender: "", senderID: sender, forSubject: subject, body: messageBody, classTime: classTime, sentTime: sentTime, sentDate: sentDate, teacherID: teacherID, absenceDate: classDate)
        
        print(message)
        messages.append(message)
        
        self.messages.sort {
            if $0.sentDate == $1.sentDate {
                return $0.sentTime < $1.sentTime
            } else {
                return $0.sentDate < $1.sentDate
            }
        }
        
        messagesDidChange?()

    }
    
    func isTableEmpty() -> Bool {
        return messages.isEmpty
    }
    
    func numberOfRows() -> Int {
        return messages.count
    }
    
    func deleteMessage(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let message = messages[indexPath.row]
        print("Deleting message: \(message.forSubject)")
        print("Deleting message 2: \(message.sentDate)")
        DatabaseManager.shared.deleteMessage(
            fullSubjectCode: message.forSubject,
            date: message.absenceDate) { [weak self] success in
                if success {
                    self?.messages.remove(at: indexPath.row)
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
    
    func cellViewModel(for indexPath: IndexPath) -> MessageCellViewModel {
        let message = messages[indexPath.row]
        return MessageCellViewModel(message: message)
    }
}
