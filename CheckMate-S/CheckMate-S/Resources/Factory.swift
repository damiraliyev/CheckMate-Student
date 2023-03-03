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
