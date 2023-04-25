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
    
    let composeButton: UIButton = {
        let button = ViewFactory.makeButton(withText: "Compose", image: UIImage(systemName: "pencil"))
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.tintColor = .black
        button.backgroundColor = .lightBlue
        return button
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
        tableView.rowHeight = view.frame.size.height / 12
        
        composeButton.addTarget(self, action: #selector(composeButtonTapped), for: .primaryActionTriggered)
        
        reasonMessagesViewModel.subscribeForNotifications()
        
        showOrHideTable()
        
        reasonMessagesViewModel.messagesDidChange = { [weak self] in
            print("Needs to reload data.")
            self?.tableView.reloadData()
            self?.showOrHideTable()
        }
        
        
    }
    @objc func composeButtonTapped(_ sender: UIButton) {
        let vc = MailComposerViewController()
        navigationController?.pushViewController(vc, animated: false)
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
        view.addSubview(composeButton)
        
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
        
        NSLayoutConstraint.activate([
            composeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            composeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -18),
            composeButton.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15),
            composeButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 3)
        ])
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.layer.cornerRadius = composeButton.frame.width / 5.5
    }
}


//MARK: - UITableViewDelegate
extension AbsenceReasonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
