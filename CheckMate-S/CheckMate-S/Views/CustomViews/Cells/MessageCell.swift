//
//  MessageCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import UIKit

class MessageCell: UITableViewCell {
    static let reuseID = "MessageCell"
    
    let subjectCodeLabel = ViewFactory.makeLabel(fontSize: 19, weight: .medium)
    
    let messageBodyLabel = ViewFactory.makeLabel(fontSize: 17, weight: .regular)
    
    let dateAndTimeLabel = ViewFactory.makeLabel(fontSize: 17, weight: .regular)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        subjectCodeLabel.textColor = .sduBlue
        
//        messageBodyLabel.numberOfLines = 2
    }
    
    private func layout() {
        contentView.addSubview(subjectCodeLabel)
        contentView.addSubview(messageBodyLabel)
        contentView.addSubview(dateAndTimeLabel)
        
        NSLayoutConstraint.activate([
            subjectCodeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            messageBodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            messageBodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            messageBodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            dateAndTimeLabel.centerYAnchor.constraint(equalTo: subjectCodeLabel.centerYAnchor),
            dateAndTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
       
    }
    
    weak var viewModel: MessageCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            subjectCodeLabel.text = viewModel.subject
            messageBodyLabel.text = viewModel.messageBody
            dateAndTimeLabel.text = viewModel.formattedDateAndTime
        }
    }
}

