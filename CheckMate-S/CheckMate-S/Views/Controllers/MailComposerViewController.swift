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
    
    let forDateLabel = ViewFactory.makeLabel(fontSize: 18, color: .sduBlue, weight: .regular, text: "For date:")
    let dateLabel = ViewFactory.makeLabel(fontSize: 18, color: .sduBlue, weight: .medium, text: "29.04.2023")
    
    let toLabel = ViewFactory.makeLabel(fontSize: 18, color: .sduBlue, weight: .regular, text: "To:")
    let teacherLabel = ViewFactory.makeLabel(fontSize: 18, color: .sduBlue, weight: .medium, text: "Bakdaulet Aidarbekov")
    
    let subjectStackView = ViewFactory.makeStackView(axis: .horizontal, spacing: 10)
    let dateStackView = ViewFactory.makeStackView(axis: .horizontal, spacing: 10)
    let recipientStackView = ViewFactory.makeStackView(axis: .horizontal, spacing: 10)
    
    let separatorLineView1: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false

        lineView.backgroundColor = .systemGray3
        
        return lineView
    }()
    
    let separatorLineView2: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false

        lineView.backgroundColor = .systemGray3
        
        return lineView
    }()
    
    let separatorLineView3: UIView = {
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
    
    var classTime = ""
    
    var teacherID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        layout()
    }
    
    private func setup() {
        setupBarButtonItem()
        textView.delegate = self
        dateLabel.text = date
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
        let sentTime = DateFormatter.getCurrentTime()
        let sentDate = String.date(from: Date())
        
        
        let dict = [
            date: [
                "sender": studentFullName,
                "subject": fullSubjectCode,
                "message": message,
                "classTime": classTime,
                "sentTime": sentTime,
                "sentDate": sentDate,
                "to": teacherID
            ]
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "message"), object: nil, userInfo: dict)
                    }
                })
                
                self?.present(alertController, animated: true)
            }
    }
    
    private func layout() {
        view.addSubview(subjectStackView)
        view.addSubview(separatorLineView1)
        view.addSubview(dateStackView)
        view.addSubview(separatorLineView2)
        view.addSubview(textView)
        view.addSubview(recipientStackView)
        view.addSubview(separatorLineView3)
        
        subjectStackView.addArrangedSubview(subjectLabel)
        subjectStackView.addArrangedSubview(fullSubjectCodeLabel)
        
        dateStackView.addArrangedSubview(forDateLabel)
        dateStackView.addArrangedSubview(dateLabel)
        
        recipientStackView.addArrangedSubview(toLabel)
        recipientStackView.addArrangedSubview(teacherLabel)
        
        NSLayoutConstraint.activate([
            subjectStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            subjectStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView1.topAnchor.constraint(equalTo: subjectStackView.bottomAnchor, constant: 8),
            separatorLineView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: separatorLineView1.bottomAnchor, constant: 8),
            dateStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView2.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 8),
            separatorLineView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            recipientStackView.topAnchor.constraint(equalTo: separatorLineView2.bottomAnchor, constant: 8),
            recipientStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView3.topAnchor.constraint(equalTo: recipientStackView.bottomAnchor, constant: 8),
            separatorLineView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView3.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: separatorLineView3.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationCenter.default.remov
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
