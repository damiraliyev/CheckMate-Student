//
//  SkeletonCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import UIKit

extension SkeletonCell: SkeletonLoadable {}

class SkeletonCell: UICollectionViewCell {
    
    static let reuseID = "SkeletonCell"
    
    
    let subjectCode = ViewFactory.makeLabel(fontSize: 17, color: .label, weight: .bold, text: "  ")
    
    let subjectName = ViewFactory.makeLabel(fontSize: 15, color: .label, weight: .medium, text: "  ")
    
    let lineView    = UIView()

    let absenceProgressBar = CustomProgressView()
    
//    let percentageLabel = ViewFactory.makeLabel(fontSize: 10, color: UIColor.sduBlue, weight: .bold)
    
    
    //Gradients
    let subjectCodeLayer = CAGradientLayer()
    let subjectNameLayer = CAGradientLayer()
    let absenceProgressLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setup()
        setupLayers()
        setupAnimation()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        subjectName.numberOfLines = 0
//        subjectCode.textColor = UIColor.sduBlue
        subjectCode.numberOfLines = 0
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
        lineView.backgroundColor = .black
        
        setupAbsenceProgressBar()
    }
    
    private func setupLayers() {
        subjectCodeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        subjectCodeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        subjectCode.layer.addSublayer(subjectCodeLayer)
        
        subjectNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        subjectNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        subjectName.layer.addSublayer(subjectNameLayer)
        
        absenceProgressLayer.startPoint = CGPoint(x: 0, y: 0.5)
        absenceProgressLayer.endPoint = CGPoint(x: 1, y: 0.5)
        absenceProgressBar.layer.addSublayer(absenceProgressLayer)
    }
    
    private func setupAnimation() {
        let codeGroup = makeAnimationGroup()
        codeGroup.beginTime = 0.0
        subjectCodeLayer.add(codeGroup, forKey: "backgroundColor")
        
        let nameGroup = makeAnimationGroup(previousGroup: codeGroup)
        subjectNameLayer.add(nameGroup, forKey: "backgroundColor")
        
        let progressGroup = makeAnimationGroup(previousGroup: nameGroup)
        absenceProgressLayer.add(progressGroup, forKey: "backgroundColor")
    }
    
    private func setupAbsenceProgressBar() {
        absenceProgressBar.translatesAutoresizingMaskIntoConstraints = false
        absenceProgressBar.layer.cornerRadius = 5
        absenceProgressBar.progressView.layer.cornerRadius = 5
        absenceProgressBar.barView.backgroundColor = .white
        absenceProgressBar.progressView.backgroundColor = .lightGreen
        absenceProgressBar.percentage = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        absenceProgressBar.percentage = 0
        subjectCode.text = nil
        subjectName.text = nil
    }
//
    override func layoutSubviews() {
        absenceProgressBar.heightAnchor.constraint(equalToConstant: frame.height / 3.5).isActive = true
        absenceProgressBar.widthAnchor.constraint(equalToConstant: frame.width / 4.5).isActive = true
        
        subjectCodeLayer.frame = subjectCode.bounds
        subjectCodeLayer.cornerRadius = 5
        
        subjectNameLayer.frame = subjectName.bounds
        subjectNameLayer.cornerRadius = 5

        absenceProgressLayer.frame = absenceProgressBar.bounds
        absenceProgressLayer.cornerRadius = 5

    }
    
    private func layout() {
        contentView.addSubview(subjectCode)
        contentView.addSubview(lineView)
        contentView.addSubview(subjectName)
        contentView.addSubview(absenceProgressBar)
        
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
            absenceProgressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
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
//                self?.percentageLabel.text = viewModel.percentage
            }
            
            
            
        }
    }
    
}
