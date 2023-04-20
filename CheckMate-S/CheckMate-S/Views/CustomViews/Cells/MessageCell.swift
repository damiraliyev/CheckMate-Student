//
//  MessageCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import UIKit

class MessageCell: UITableViewCell {
    static let reuseID = "MessageCell"
    
    let subjectCodeLabel = ViewFactory.makeLabel(fontSize: 17, weight: .regular)
    
    let messageBodyLabel = ViewFactory.makeLabel(fontSize: 17, weight: .regular)
    
    let timeLabel = ViewFactory.makeLabel(fontSize: 17, weight: .regular)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
    }
    
    private func layout() {
        contentView.addSubview(subjectCodeLabel)
        contentView.addSubview(messageBodyLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            subjectCodeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            messageBodyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageBodyLabel.leadingAnchor.constraint(equalTo: subjectCodeLabel.trailingAnchor, constant: 16),
            messageBodyLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8)
        ])
        
       
    }
    
    weak var viewModel: MessageCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            subjectCodeLabel.text = viewModel.subject
            messageBodyLabel.text = viewModel.messageBody
            timeLabel.text = viewModel.time
        }
    }
}

