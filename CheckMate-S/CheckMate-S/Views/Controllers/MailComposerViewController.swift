//
//  MailComposerViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 20.04.2023.
//

import UIKit

class MailComposerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        layout()
    }
    
    private func setup() {
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
    }
    
    private func layout() {
        
    }
}
