//
//  MailComposerViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 20.04.2023.
//

import UIKit

class MailComposerViewController: UIViewController {
    
    let subjectLabel: UILabel = {
        let label = ViewFactory.makeLabel(fontSize: 18, color: .sduBlue, weight: .regular, text: "Subject:")
        
        return label
    }()
    
    let fullSubjectCodeLabel: UILabel = {
        let label = ViewFactory.makeLabel(fontSize: 18, color: .sduBlue, weight: .medium, text: "CSS342[01-N]")
        
        return label
    }()
    
    let stackView = ViewFactory.makeStackView(axis: .horizontal, spacing: 10)
    
    let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false

        lineView.backgroundColor = .systemGray3
        
        return lineView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Write your message here..."
    
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = .sduBlue
        textView.isScrollEnabled = true
 
        return textView
    }()
    
    var hasTyped = false
    
    var date = ""
    
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        layout()
    }
    
    private func setup() {
        setupBarButtonItem()
        textView.delegate = self
    }
    
    private func setupBarButtonItem() {
        let rightBarItem = UIBarButtonItem(
            image: UIImage(systemName: "paperplane"),
            style: .plain,
            target: self,
            action: #selector(sendMessage))
        rightBarItem.tintColor = .sduBlue
        
        
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc func sendMessage() {
        let studentFullName = (UserDefaults.standard.value(forKey: "name") as? String ?? "") + " " + (UserDefaults.standard.value(forKey: "surname") as? String ?? "")
        let fullSubjectCode = fullSubjectCodeLabel.text ?? "CSS"
        let message = textView.text
        
        let dict = [
            "sender": studentFullName,
            "subject": fullSubjectCode,
            "message": message,
            "date": date,
            "time": time
        ]
        
        DatabaseManager.shared.sendMessage(
            fullSubjectCode: fullSubjectCode,
            dict: dict as [String: Any]) { [weak self] isSuccessfull in
                let alertController = UIAlertController(title: "Success!", message: "Your message was sent successfully!", preferredStyle: .alert)
                
                if !isSuccessfull {
                    alertController.title = "Error"
                    alertController.message = "For some reason, your message was not sent."
                }
                
                alertController.addAction(UIAlertAction(title: "Done", style: .default) { _ in
                    if isSuccessfull {
                        self?.textView.text = "Write your message here..."
                        self?.textView.textColor = .sduBlue
                        self?.hasTyped = false
                    }
                })
                
                self?.present(alertController, animated: true)
            }
    }
    
    private func layout() {
        view.addSubview(stackView)
        view.addSubview(separatorLineView)
        view.addSubview(textView)
        
        stackView.addArrangedSubview(subjectLabel)
        stackView.addArrangedSubview(fullSubjectCodeLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            separatorLineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
    }
}


extension MailComposerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !hasTyped {
            textView.text = ""
            hasTyped = true
        }
        
        textView.textColor = .label
    }

}
