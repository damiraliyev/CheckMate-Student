//
//  AbsencesCell.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 06.05.2023.
//

import UIKit

class AbscencesCell: UICollectionViewCell {
    
    static let reuseID = "AbsenceCell"
    
    let dateLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduLightBlue, weight: .regular,text: "06 May")
    
    let timeLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .regular, text: "15:00")
    
    let absenceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "x.circle.fill")
        imageView.tintColor = .systemRed
        
        return imageView
    }()
    
    let stack = ViewFactory.makeStackView(axis: .horizontal, spacing: 20)
    
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
        layer.cornerRadius = 8
        clipsToBounds = true
        stack.distribution = .fillEqually
    }
    
    private func layout() {
        
//        contentView.addSubview(stack)
//
//        stack.addArrangedSubview(dateLabel)
//        stack.addArrangedSubview(timeLabel)
//        stack.addArrangedSubview(absenceImageView)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(absenceImageView)
        
//        NSLayoutConstraint.activate([
//            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])

        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            absenceImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            absenceImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    weak var viewModel: AbsenceCollectionViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            
            dateLabel.text = viewModel.date
            timeLabel.text = viewModel.time
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stack.spacing = contentView.frame.size.width / 6
        NSLayoutConstraint.activate([
            absenceImageView.heightAnchor.constraint(equalToConstant: contentView.frame.size.height / 2.5),
            absenceImageView.widthAnchor.constraint(equalToConstant: contentView.frame.size.height / 2.5)
        ])
        
        
    }
}
