//
//  Factory.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 03.03.2023.
//

import Foundation
import UIKit

func makeStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.spacing = spacing
    
    return stackView
}

func makeLabel(fontSize: CGFloat, color: UIColor? = nil, weight: UIFont.Weight, text: String? = nil) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    
    if let color = color {
        label.textColor = color
    }
    
    if let text = text {
        label.text = text
    }
    
    return label
}
