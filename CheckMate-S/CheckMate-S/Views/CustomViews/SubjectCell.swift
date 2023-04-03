//
//  ClassCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

//class ClassCell: UICollectionViewCell {
//
//    static let reuseID = "ClassCell"
//
//    let stackView = makeStackView(axis: .vertical, spacing: 8)
//
//    let subjectCode = makeLabel(fontSize: 20, color: .label, weight: .bold, text: "CSS 342")
//
//    let subjectName = makeLabel(fontSize: 15, color: .label, weight: .medium, text: "Sofware Engineering")
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .white
//
//        setup()
//        layout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        subjectName.textAlignment = .center
//        stackView.alignment = .center
//        subjectName.numberOfLines = 0
//        layer.cornerRadius = 10
//    }
//
//    private func layout() {
//        contentView.addSubview(stackView)
//
//        stackView.addArrangedSubview(subjectCode)
//        stackView.addArrangedSubview(subjectName)
//
//
//
//        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
//        ])
//    }
//
//    weak var viewModel: CollectionViewCellViewModelType? {
//        willSet(viewModel) {
//            guard let viewModel = viewModel else {
//                return
//            }
//
//            subjectCode.text = viewModel.subjectCode
//            subjectName.text = viewModel.subjectName
//        }
//    }
//
//
//}


final class SubjectCell: UICollectionViewCell {
    
    static let reuseID = "SubjectCell"
    
    let subjectCode = ViewFactory.makeLabel(fontSize: 17, color: .label, weight: .bold, text: "CSS 342")
    
    let subjectName = ViewFactory.makeLabel(fontSize: 15, color: .label, weight: .medium, text: "Sofware Engineering")
    
    let lineView    = UIView()

    
    let absenceProgressBar = CustomProgressView()
    
    let percentageLabel = ViewFactory.makeLabel(fontSize: 10, color: UIColor.sduBlue, weight: .bold)
    
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
        layer.cornerRadius = 10
        layer.borderWidth = 1
        subjectName.numberOfLines = 0
        subjectCode.textColor = UIColor.sduBlue
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
        lineView.backgroundColor = .black
        
        setupAbsenceProgressBar()
        
        percentageLabel.text = "0%"
        
        
    }
    
    private func setupAbsenceProgressBar() {
        absenceProgressBar.translatesAutoresizingMaskIntoConstraints = false
        absenceProgressBar.layer.borderWidth = 1.5
        absenceProgressBar.layer.cornerRadius = 5
        absenceProgressBar.progressView.layer.cornerRadius = 5
        absenceProgressBar.barView.backgroundColor = .white
        absenceProgressBar.progressView.backgroundColor = .lightGreen
        absenceProgressBar.percentage = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        absenceProgressBar.percentage = 0
        percentageLabel.text = "0%"
        subjectCode.text = nil
        subjectName.text = nil
    }
//
    override func layoutSubviews() {
        absenceProgressBar.heightAnchor.constraint(equalToConstant: frame.height / 3.5).isActive = true
        absenceProgressBar.widthAnchor.constraint(equalToConstant: frame.width / 4.5).isActive = true
        percentageLabel.font = UIFont.systemFont(ofSize: frame.height / 6.5)
    }
    
    private func layout() {
        contentView.addSubview(subjectCode)
        contentView.addSubview(lineView)
        contentView.addSubview(subjectName)
        contentView.addSubview(absenceProgressBar)
        contentView.addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            subjectCode.centerYAnchor.constraint(equalTo: centerYAnchor),
            subjectCode.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            
            lineView.topAnchor.constraint(equalTo: subjectCode.topAnchor, constant: -5),
            lineView.leadingAnchor.constraint(equalTo: subjectCode.trailingAnchor, constant: 8),
            lineView.bottomAnchor.constraint(equalTo: subjectCode.bottomAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            subjectName.centerYAnchor.constraint(equalTo: subjectCode.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 8),
            subjectName.trailingAnchor.constraint(equalTo: absenceProgressBar.leadingAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            absenceProgressBar.centerYAnchor.constraint(equalTo: subjectName.centerYAnchor),
//            absenceProgressBar.leadingAnchor.constraint(equalTo: subjectName.trailingAnchor, constant: 16),
            absenceProgressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            percentageLabel.centerYAnchor.constraint(equalTo: absenceProgressBar.centerYAnchor),
            percentageLabel.centerXAnchor.constraint(equalTo: absenceProgressBar.centerXAnchor)
        ])
        
    }
    
    
    
    
    weak var viewModel: CollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            
            subjectCode.text = viewModel.subjectCode
            subjectName.text = viewModel.subjectName
            
            DispatchQueue.main.async { [weak self] in
                self?.absenceProgressBar.percentage = viewModel.progress
                self?.absenceProgressBar.progressView.backgroundColor = viewModel.progressColor
                self?.absenceProgressBar.updateProgressViewWidthConstraint()
                self?.percentageLabel.text = viewModel.percentage
            }
            
            
            
        }
    }
}
