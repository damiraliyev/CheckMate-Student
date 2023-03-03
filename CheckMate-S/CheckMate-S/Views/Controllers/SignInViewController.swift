//
//  SignInViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 03.03.2023.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SDU-logo")
        
        return imageView
    }()
    
    let stackView = makeStackView(axis: .vertical, spacing: 0)
    
    let usernameTextField: SignInTextFieldView = {
        let textFieldView = SignInTextFieldView(withText: "Email")
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.textField.keyboardType = .emailAddress
        return textFieldView
    }()
    
    let passwordTextField: SignInTextFieldView = {
        let textFieldView = SignInTextFieldView(withText: "Password")
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.textField.keyboardType = .default
        textFieldView.textField.isSecureTextEntry = true
        textFieldView.textField.isUserInteractionEnabled = true
        return textFieldView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addAllSubViews()
        layout()
        
        usernameTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
       
    }
    
    private func addAllSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
    }
    
    
    private func layout() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.size.height / 8),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: view.frame.size.height / 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            stackView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15 * 2)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15),
            passwordTextField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15),
            
        ])
    
  
        
        
       
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
