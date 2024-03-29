//
//  SDUGradientButton.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

final class SDUGradientButton: UIButton {
    
    private var gradientLayer = CAGradientLayer()
    
    init(withText text: String) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        
        
        setupGradientLayer()
        
        self.setTitle(text, for: .normal)
        titleLabel?.text = text
        
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel?.textColor = .white
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
          UIColor(red: 0, green: 0.141, blue: 0.412, alpha: 1).cgColor,
          UIColor(red: 0.608, green: 0.157, blue: 0.165, alpha: 1).cgColor
        ]
        
        gradientLayer.locations = [0.01, 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        gradientLayer.position = center
        
        layer.addSublayer(gradientLayer)

        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = layer.bounds
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 50)
    }
}
