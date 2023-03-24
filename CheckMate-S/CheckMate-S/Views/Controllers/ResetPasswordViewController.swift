//
//  ResetPasswordViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 23.03.2023.
//

import Foundation
import UIKit

class ResetPasswordViewController: UIViewController {
    
    let headerLabel = ViewFactory.makeLabel(fontSize: 25, color: .sduBlue, weight: .semibold, text: "Reset password")
    
    let descriptionLabel = ViewFactory.makeLabel(fontSize: 17, weight: .regular)
    
    let emailField = SignInTextFieldView(withText: "Email")
    
    let resetButton = SDUGradientButton(withText: "Reset")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        layout()
        
    }
    
    private func setup() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Enter the email associated with your account and we’ll send an email with instructions to reset your password."
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.textField.layer.borderColor = UIColor.sduLightBlue.cgColor
        emailField.hintLabel.textColor = .sduLightBlue
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(didTapReset), for: .primaryActionTriggered)
    }
    
    @objc func didTapReset(_ sender: UIButton) {
        AuthManager.shared.auth.sendPasswordReset(withEmail: emailField.textField.text ?? "") { [weak self] error in
            guard error == nil else {
                let alertController = UIAlertController(
                    title: "Error",
                    message: "\(error?.localizedDescription ?? "Error")",
                    preferredStyle: .alert
                )
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alertController, animated: true)
                return
            }
            
            let alertController = UIAlertController(title: "Success!", message: "Check your mail to reset your password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertController, animated: true)
            
            self?.emailField.textField.text = ""
        }
        sender.animatePress()
    }
    
    private func layout() {
        view.addSubview(headerLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailField)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            emailField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 17),
            emailField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: view.frame.height / 15),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15),
            resetButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: view.frame.size.height / 20),
            resetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
