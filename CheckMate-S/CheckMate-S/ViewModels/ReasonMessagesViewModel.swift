//
//  AbsenceReasonViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import Foundation

class ReasonMessagesViewModel {
    
    var messages: [Message] = [
        Message(
            sender: "Damir Aliyev",
            senderID: "200107116",
            forSubject: "CSS342[01-N]",
            body: "Please, put full point to this project.",
            time: "14:00")
    ]
    
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
