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
    
    var sentDate: String {
        return message.sentDate
    }
    
    var formattedDateAndTime: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let date = dateFormatter.date(from: sentDate) else {
            print("IS NOT ABLE TO CONVERT date from \(sentDate)")
            return ""
        }

        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MMMM"
        let formattedString = dateFormatter2.string(from: date)

        
        return formattedString + ", " + time
    }
}
