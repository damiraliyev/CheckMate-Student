//
//  ClassCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 17.03.2023.
//

import Foundation
import UIKit

final class ClassCell: UICollectionViewCell {
    
    static let reuseID = "ClassCell"
    
    private let startLabel = ViewFactory.makeLabel(fontSize: 15, color: .sduBlue, weight: .regular, text: "12:00")
    private let endLabel = ViewFactory.makeLabel(fontSize: 15, color: .sduBlue, weight: .regular, text: "12:50")
    
    let infoButton = ViewFactory.makeButton(withText: "", image: UIImage(systemName: "info.circle"))
    
    let subjectName = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .bold, text: "Software Engineering")
    
    let subjectCode = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .medium, text: "[01-N]")
    
    private let stackView = ViewFactory.makeStackView(axis: .vertical, spacing: 3)
    private let stackView2 = ViewFactory.makeStackView(axis: .vertical, spacing: 3)
    
    let attendanceButton: UIButton = {
        let button = ViewFactory.makeButton(withText: "", image: UIImage(systemName: "circle"))
        button.imageView?.layer.transform = CATransform3DMakeScale(1.7, 1.7, 1.7)
        button.imageView?.tintColor = .gray
//        button.addTarget(self, action: #selector(attendanceButtonTapped), for: .primaryActionTriggered)
        return button
    }()
    
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
//        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        stackView2.alignment = .center
       
    }
    
 
    
    @objc func didTapInfo() {
        
        guard let collectionView = superview as? UICollectionView else {
            return
        }

        
        guard let viewController = collectionView.delegate as? UIViewController else {
            return
        }
        
        let alertController = UIAlertController(
            title: "Info",
            message: "If duration of the class is more than 50 minutes, there are 10 minutes break between each class",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController.present(alertController, animated: true)
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(startLabel)
        stackView.addArrangedSubview(endLabel)
        
        contentView.addSubview(stackView2)
        
        stackView2.addArrangedSubview(subjectName)
        stackView2.addArrangedSubview(subjectCode)
        
        contentView.addSubview(infoButton)
        
        contentView.addSubview(attendanceButton)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            stackView2.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            attendanceButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            attendanceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            attendanceButton.heightAnchor.constraint(equalToConstant: 35),
            attendanceButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        
    }
    
//    @objc func attendanceButtonTapped(_ sender: UIButton) {
//        print("tapped")
//    }
    
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
            
            
            let startHour = Int(startLabel.text?.prefix(2) ?? "0") ?? 0
            let endHour = Int(endLabel.text?.prefix(2) ?? "0") ?? 0
            print("before if", startHour)
            print("Before if", endHour)
            if (endHour - startHour) >= 1 {
               
                infoButton.tintColor = .systemBlue
                infoButton.addTarget(self, action: #selector(didTapInfo), for: .primaryActionTriggered)
            } else {
                print(startHour)
                print(endHour)
                infoButton.isHidden = true
            }
            
            if viewModel.attended == 1 {
                attendanceButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                attendanceButton.imageView?.tintColor = .systemGreen
            } else {
                attendanceButton.setImage(UIImage(systemName: "circle"), for: .normal)
                attendanceButton.imageView?.tintColor = .gray
            }
        }
    }
    
    
}
