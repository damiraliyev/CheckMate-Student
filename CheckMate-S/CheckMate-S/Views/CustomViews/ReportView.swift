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
    
    let presentImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let presenceCountLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue,weight: .regular, text: "45")
    
    let absentImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "x.circle.fill"))
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let absenceCountLabel = ViewFactory.makeLabel(fontSize: 17, color: .sduBlue, weight: .regular, text: "0")
    
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
        
        viewDetailsLabel.isUserInteractionEnabled = true
        
    }
    
    private func layout() {
        addSubview(hoursLabel)
        addSubview(hoursCountLabel)

        addSubview(presentImageView)
        addSubview(presenceCountLabel)

        addSubview(absentImageView)
        addSubview(absenceCountLabel)
     
        addSubview(viewDetailsLabel)
        
        addSubview(tableView)

        NSLayoutConstraint.activate([
            hoursLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            hoursLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            hoursCountLabel.centerXAnchor.constraint(equalTo: hoursLabel.centerXAnchor),
            hoursCountLabel.centerYAnchor.constraint(equalTo: presenceCountLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            presentImageView.centerYAnchor.constraint(equalTo: hoursLabel.centerYAnchor),
            presentImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            presenceCountLabel.centerXAnchor.constraint(equalTo: presentImageView.centerXAnchor),
            presenceCountLabel.topAnchor.constraint(equalTo: presentImageView.bottomAnchor, constant: 16)
        ])
//
        NSLayoutConstraint.activate([
            absentImageView.centerYAnchor.constraint(equalTo: hoursLabel.centerYAnchor),
            absentImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            absenceCountLabel.centerXAnchor.constraint(equalTo: absentImageView.centerXAnchor),
            absenceCountLabel.topAnchor.constraint(equalTo: absentImageView.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            viewDetailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            viewDetailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: viewDetailsLabel.bottomAnchor, constant: 8),
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        presentImageView.heightAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        presentImageView.widthAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        absentImageView.heightAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
        absentImageView.widthAnchor.constraint(equalToConstant: frame.size.height / 4.5).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 100)
    }
    
}
