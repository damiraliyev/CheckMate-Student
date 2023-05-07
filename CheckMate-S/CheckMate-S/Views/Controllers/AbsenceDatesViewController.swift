//
//  AbsenceDatesViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 06.05.2023.
//

import UIKit

class AbsenceDatesViewController: UIViewController {
    
    let shortSubjectCode: String
    
    let absencesCollectionViewViewModel = AbsencesCollectionViewViewModel()
    
    let titleLabel = ViewFactory.makeLabel(fontSize: 25, weight: .medium, text: "Absences")
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let doneButton: UIButton = {
        let button = ViewFactory.makeButton(withText: "Done")
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .primaryActionTriggered)
        return button
    }()
    
    init(shortSubjectCode: String) {
        
        self.shortSubjectCode = shortSubjectCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Absences"
        view.backgroundColor = .secondarySystemBackground
        setup()
        layout()
        absencesCollectionViewViewModel.getAbsenceClasses(shortSubjectCode: shortSubjectCode) { [weak self] in
//            print("AbsenceVC", time, statuses)
            self?.collectionView.reloadData()
        }
    }
    
    @objc func doneTapped() {
        self.dismiss(animated: true)
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AbscencesCell.self, forCellWithReuseIdentifier: AbscencesCell.reuseID)
        collectionView.backgroundColor = .secondarySystemBackground
//        titleLabel.text = "Absences: \()"
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        view.addSubview(lineView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension AbsenceDatesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = 16 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: view.frame.height / 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension AbsenceDatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AbscencesCell.reuseID, for: indexPath) as! AbscencesCell
        
        let cellViewModel = absencesCollectionViewViewModel.absenceClassCellViewModel(for: indexPath)
        
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        absencesCollectionViewViewModel.numberOfRows()
    }
}
