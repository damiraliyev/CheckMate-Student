//
//  ReportView.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.05.2023.
//

import UIKit

class ReportView: UIView {
    
    let hoursLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .regular, text: "Total Hours")
    let hoursCountLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .regular, text: "45")
    let stackHours = ViewFactory.makeStackView(axis: .vertical, spacing: 10)
    
    let presentImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let presenceCountLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue,weight: .regular, text: "45")
    let stackPresence = ViewFactory.makeStackView(axis: .vertical, spacing: 10)
    
    let absentImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "x.circle.fill"))
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let absenceCountLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .regular, text: "0")
    let stackAbsence = ViewFactory.makeStackView(axis: .vertical, spacing: 10)
    
    let bluePImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "p"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let pCountLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .regular, text: "0")
    let stackP = ViewFactory.makeStackView(axis: .vertical, spacing: 10)
    
    let stack = ViewFactory.makeStackView(axis: .horizontal, spacing: 8)
    
    let viewDetailsLabel = ViewFactory.makeLabel(fontSize: 17, color: .systemGray, weight: .regular, text: "View details")
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
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
        layer.cornerRadius = 10
        clipsToBounds = true
        
        stack.distribution = .equalSpacing
        
        stackHours.alignment = .center
        stackPresence.alignment = .center
        stackAbsence.alignment = .center
        stackP.alignment = .center
        
        viewDetailsLabel.isUserInteractionEnabled = true
        
    }
    
    private func layout() {
            
        addSubview(stack)
        
        stack.addArrangedSubview(stackHours)
        stack.addArrangedSubview(stackPresence)
        stack.addArrangedSubview(stackAbsence)
        stack.addArrangedSubview(stackP)
        
        stackHours.addArrangedSubview(hoursLabel)
        stackHours.addArrangedSubview(hoursCountLabel)
        
        stackPresence.addArrangedSubview(presentImageView)
        stackPresence.addArrangedSubview(presenceCountLabel)
//
        stackAbsence.addArrangedSubview(absentImageView)
        stackAbsence.addArrangedSubview(absenceCountLabel)
//
        stackP.addArrangedSubview(bluePImageView)
        stackP.addArrangedSubview(pCountLabel)
     
        addSubview(viewDetailsLabel)
        
        addSubview(tableView)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            viewDetailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            viewDetailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        presentImageView.heightAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        presentImageView.widthAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        absentImageView.heightAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        absentImageView.widthAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        bluePImageView.heightAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        bluePImageView.widthAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 100)
    }
    
}
