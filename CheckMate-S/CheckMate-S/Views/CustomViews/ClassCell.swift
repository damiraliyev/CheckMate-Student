//
//  ClassCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 17.03.2023.
//

import Foundation
import UIKit

class ClassCell: UICollectionViewCell {
    
    static let reuseID = "ClassCell"
    
    private let startLabel = makeLabel(fontSize: 15, color: .sduBlue, weight: .regular, text: "12:00")
    private let endLabel = makeLabel(fontSize: 15, color: .sduBlue, weight: .regular, text: "12:50")
    
    let subjectName = makeLabel(fontSize: 17, color: .sduBlue, weight: .bold, text: "Software Engineering")
    
    let subjectCode = makeLabel(fontSize: 17, color: .sduBlue, weight: .medium, text: "[01-N]")
    
    private let stackView = makeStackView(axis: .vertical, spacing: 3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(startLabel)
        stackView.addArrangedSubview(endLabel)
        
        contentView.addSubview(subjectName)
        contentView.addSubview(subjectCode)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            subjectCode.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectCode.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            subjectName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
    }
    
    func configure(viewModel: ClassCollectionViewCellViewModelType) {
        subjectName.text = viewModel.subjectName
        subjectCode.text = viewModel.subjectCode
        startLabel.text = viewModel.startTime
        endLabel.text = viewModel.endTime
    }
    
    weak var viewModel: ClassCollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            
            subjectName.text = viewModel.subjectName
            subjectCode.text = viewModel.subjectCode
            startLabel.text = viewModel.startTime
            endLabel.text = viewModel.endTime
        }
    }
    
    
}
