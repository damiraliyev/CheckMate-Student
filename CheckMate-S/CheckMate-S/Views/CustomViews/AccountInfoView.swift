//
//  AccountInfoView.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

final class AccountInfoView: UIView {
    
    weak var accountInfoViewModel: AccountInfoViewModelType?
    
    private var gradientLayer = CAGradientLayer()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "avatar-man")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let stackView = ViewFactory.makeStackView(axis: .vertical, spacing: 8)
    
//    var fullName = makeLabel(fontSize: 16, color: .white, weight: .bold)
    
    var fullName = UILabel()
        .setAutoResizingMask(to: false)
        .setFont(font: .systemFont(ofSize: 16, weight: .bold))
        .setColor(color: .white)
    
    
    var email = ViewFactory.makeLabel(fontSize: 16, color: .white, weight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
        
//        accountInfoViewModel = AccountInfoViewModel(student: Student(name: "Askar", surname: "Askarov", email: "200107111"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        fullName.text = "Askar Askarov"
        email.text    = "200107111@stu.sdu.edu.kz"
        email.adjustsFontSizeToFitWidth = true
        
        createGradient()
    }
    
    private func layout() {
        addSubview(imageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(fullName)
        stackView.addArrangedSubview(email)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func createGradient() {
        gradientLayer.colors = [
          UIColor(red: 0, green: 0.141, blue: 0.412, alpha: 1).cgColor,
          UIColor(red: 0.608, green: 0.157, blue: 0.165, alpha: 1).cgColor
        ]
        gradientLayer.locations  = [0.01, 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.bounds     = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        gradientLayer.position   = center
        
        layer.addSublayer(gradientLayer)
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: frame.size.width / 6),
            imageView.heightAnchor.constraint(equalToConstant: frame.size.width / 6),
        ])
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        
        gradientLayer.frame = layer.bounds
        
    }
    
    func accountInfo() {
        fullName.text = accountInfoViewModel?.fullName
        email.text    = accountInfoViewModel?.email
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
