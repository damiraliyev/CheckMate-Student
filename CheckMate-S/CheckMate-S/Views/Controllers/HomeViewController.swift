//
//  HomeViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    let accountInfoView = AccountInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setup()
        addAllSubViews()
        layout()
    }
    
    private func setup() {
        accountInfoView.translatesAutoresizingMaskIntoConstraints = false
        
       
    }
    
    private func addAllSubViews() {
        view.addSubview(accountInfoView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            accountInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            accountInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            accountInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            accountInfoView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 9)
        ])
    }
    
    
}
