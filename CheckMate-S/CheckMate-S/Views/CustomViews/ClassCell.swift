//
//  ClassCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

class ClassCell: UICollectionViewCell {
    
    static let reuseID = "ClassCell"
    
    let stackView = makeStackView(axis: .vertical, spacing: 8)
    
    let code = makeLabel(fontSize: 20, color: .label, weight: .bold, text: "CSS 342")
    
    let subjectName = makeLabel(fontSize: 15, color: .label, weight: .medium, text: "Sofware Engineering")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        subjectName.textAlignment = .center
        stackView.alignment = .center
        subjectName.numberOfLines = 0
        layer.cornerRadius = 10
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(code)
        stackView.addArrangedSubview(subjectName)
        
        
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    
}
