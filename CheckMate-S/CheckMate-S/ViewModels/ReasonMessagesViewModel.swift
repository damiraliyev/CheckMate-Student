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
                
                let message = Message(sender: "", senderID: "", forSubject: subject, body: messageBody, classTime: "", sentTime: sentTime)
                self?.messages.append(message)
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
        print("Message info", messageInfo)
        
        for (key, _) in messageInfo {
            print("IN for loop", key)
            messageBody = (messageInfo[key] as? [String: Any])?["message"] as? String ?? ""
            subject = (messageInfo[key] as? [String: Any])?["subject"] as? String ?? ""
            classTime = (messageInfo[key] as? [String: Any])?["classTime"] as? String ?? ""
            sentTime = (messageInfo[key] as? [String: Any])?["sentTime"] as? String ?? ""
            sender = (messageInfo[key] as? [String: Any])?["sender"] as? String ?? ""
        }
        
        
        
        let message = Message(sender: "", senderID: sender, forSubject: subject, body: messageBody, classTime: classTime, sentTime: sentTime)
        
        messages.append(message)
        messagesDidChange?()

    }
    
    func isTableEmpty() -> Bool {
        return messages.isEmpty
    }
    
    func numberOfRows() -> Int {
        return messages.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> MessageCellViewModel {
        let message = messages[indexPath.row]
        
        return MessageCellViewModel(message: message)
    }
}
