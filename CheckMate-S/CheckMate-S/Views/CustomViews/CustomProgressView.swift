//
//  CustomProgressView.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 01.04.2023.
//

import Foundation
import UIKit

class CustomProgressView: UIView {
    
    let barView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var percentage: Float = 0
    
    var progressViewWidthConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
    }
    
    private func layout() {
        addSubview(barView)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: topAnchor),
            barView.leadingAnchor.constraint(equalTo: leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: trailingAnchor),
            barView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: barView.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: barView.leadingAnchor),
            progressView.bottomAnchor.constraint(equalTo: barView.bottomAnchor)
        ])
        
        progressViewWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: CGFloat(0))
        progressViewWidthConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let barWidth = barView.frame.width
        print("BarWidth", barWidth)
        let progress = CGFloat(percentage) * barWidth
        print("PROGRESS IN CUSTOM UIVIEW", progress)
        print("Custom progress view width", progressView.frame.width)
        layoutIfNeeded()
        
    }
    
    func updateProgressViewWidthConstraint() {
        let barWidth = barView.frame.width
        print("BarWidth", barWidth)
        let progress = CGFloat(percentage) * barWidth
        print("PROGRESS IN CUSTOM UIVIEW", progress)
        
        progressViewWidthConstraint.constant = CGFloat(progress)
        print("Custom progress view width", progressView.frame.width)
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 20)
    }
}
