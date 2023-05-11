//
//  AbsenceReasonViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 19.04.2023.
//

import UIKit

class AbsenceReasonViewController: UIViewController {
    
    let reasonMessagesViewModel = ReasonMessagesViewModel()
    
    let gmailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "gmailImage")
        imageView.isHidden = true
        return imageView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Messages"
        setup()
        layout()
        
        reasonMessagesViewModel.fetchMessages { [weak self] in
            self?.tableView.reloadData()
            self?.showOrHideTable()
        }
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseID)
        tableView.rowHeight = view.frame.size.height / 10.5
        
        reasonMessagesViewModel.subscribeForNotifications()
        
        showOrHideTable()
        
        reasonMessagesViewModel.messagesDidChange = { [weak self] in
            print("Needs to reload data.")
            self?.tableView.reloadData()
            self?.showOrHideTable()
        }

        
    }
    
    private func showOrHideTable() {
        if reasonMessagesViewModel.isTableEmpty() {
            tableView.isHidden = true
            gmailImageView.isHidden = false
        } else {
            tableView.isHidden = false
            gmailImageView.isHidden = true
        }
    }
    
    private func layout() {
        view.addSubview(gmailImageView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            gmailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gmailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


//MARK: - UITableViewDelegate
extension AbsenceReasonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = reasonMessagesViewModel.messages[indexPath.row]
        let vc = MailComposerViewController()
        vc.fullSubjectCodeLabel.text = message.forSubject
        vc.dateLabel.text = message.absenceDate
        vc.teacherLabel.text = message.teacherID
//        vc.classTime = message.classTime
//        vc.teacherID = message.
        vc.textView.text = message.body
        vc.textView.isUserInteractionEnabled = false
//        vc.navigationItem.rightBarButtonItem = nil
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            reasonMessagesViewModel.deleteMessage(at: indexPath) { [weak self] success in
                if success {
                    self?.tableView.reloadData()
                    self?.showOrHideTable()
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Could not delete the message", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Done", style: .default))
                    self?.present(alertController, animated: true)
                }
                
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension AbsenceReasonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonMessagesViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseID) as! MessageCell
        
        let cellViewModel = reasonMessagesViewModel.cellViewModel(for: indexPath)
        
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    
}
