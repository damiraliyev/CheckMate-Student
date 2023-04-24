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
            action: nil)
        rightBarItem.tintColor = .sduBlue
        
        navigationItem.rightBarButtonItem = rightBarItem
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
}


extension MailComposerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .label
    }
}
