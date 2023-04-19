//
//  AbsenceReasonViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import Foundation

class ReasonMessagesViewModel {
    
    var messages: [Message] = []
    
    func numberOfRows() -> Int {
        return messages.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> MessageCellViewModel {
        let message = messages[indexPath.row]
        
        return MessageCellViewModel(message: message)
    }
}
