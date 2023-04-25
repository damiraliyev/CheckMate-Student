//
//  MessageCellViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import Foundation

class MessageCellViewModel {
    
    private let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    var subject: String {
        return message.forSubject
    }
    
    var messageBody: String {
        return message.body
    }
    
    var time: String {
        return message.sentTime
    }
}
