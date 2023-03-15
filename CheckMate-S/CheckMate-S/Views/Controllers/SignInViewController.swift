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
    
    let stackView = makeStackView(axis: .vertical, spacing: 60)
    
    let IDTextField: SignInTextFieldView = {
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
    
    
    let sduGradientButton: SDUGradientButton = {
        let button = SDUGradientButton(withText: "Sign in")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addAllSubViews()
        setup()
        layout()
       
    }
    
    private func addAllSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        
        stackView.addArrangedSubview(IDTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(sduGradientButton)
    }
    
    
    private func setup() {
        IDTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        sduGradientButton.addTarget(self, action: #selector(didTapSignIn), for: .primaryActionTriggered)
    }
    
    
    private func layout() {
        let stackSpacing = view.frame.size.height / 13
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.size.height / 8),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: view.frame.size.height / 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        stackView.spacing = stackSpacing
        
        NSLayoutConstraint.activate([
            IDTextField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 14.5),
            passwordTextField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 14.5),
        ])
        
        NSLayoutConstraint.activate([
            sduGradientButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: view.frame.size.height / 18),
            sduGradientButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sduGradientButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sduGradientButton.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15)
        ])
       
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Actions

extension SignInViewController {
    
    @objc func didTapSignIn() {
        IDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let domain = ""
       
        guard var email = IDTextField.textField.text,
              let password = passwordTextField.textField.text else {
            return
        }
        
        email += domain
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                let vc = HomeViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
