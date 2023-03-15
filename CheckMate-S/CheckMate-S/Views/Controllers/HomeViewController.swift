//
//  HomeViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
//    private var collectionViewViewModel: CollectionViewViewModelType?
    
    private var homeViewModel: HomeViewModelType?
    
    let accountInfoView = AccountInfoView()
    
    let myClassesLabel = makeLabel(fontSize: 28, weight: .semibold, text: "My Classes")
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        let collectionViewViewModel = CollectionViewViewModel()
        let accountInfoViewModel = AccountInfoViewModel(student: Student(name: UserDefaults.standard.value(forKey: "fullname") as! String, surname: "", email: "bakdaulet.aidarbekov@sdu.edu.kz"))
        
        homeViewModel = HomeViewModel(collectionViewViewModel: collectionViewViewModel, accountInfoViewModel: accountInfoViewModel)
        
        
        homeViewModel?.collectionViewViewModel?.querySubjects(
            name: "Bakdaulet",
            surname: "Aidarbekov",
            completion: { [weak self] in
                self?.collectionView.reloadData()
            })
        
        setup()
        addAllSubViews()
        layout()
    }
    
    private func setup() {
        accountInfoView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(ClassCell.self, forCellWithReuseIdentifier: ClassCell.reuseID)
        
        setupInfo()
        
        let db = DB()
        
        db.attendanceCourseStudentIDValue()
        
        testQuery()
    }
    
    private func addAllSubViews() {
        view.addSubview(accountInfoView)
        view.addSubview(myClassesLabel)
        view.addSubview(collectionView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            accountInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            accountInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            accountInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            accountInfoView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 9)
        ])
        
        NSLayoutConstraint.activate([
            myClassesLabel.topAnchor.constraint(equalTo: accountInfoView.bottomAnchor, constant: 24),
            myClassesLabel.leadingAnchor.constraint(equalTo: accountInfoView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: myClassesLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
       
    }
    
    override func viewDidLayoutSubviews() {
        createGradientToLabel()
    }
    
    private func createGradientToLabel() {
        let gradient = getGradientLayer(bounds: myClassesLabel.bounds)
        
        myClassesLabel.textColor = gradientColor(bounds: myClassesLabel.bounds, gradientLayer: gradient)
    }
    
    private func setupInfo() {
        accountInfoView.fullName.text = homeViewModel?.accountInfoViewModel?.fullName
        accountInfoView.email.text = homeViewModel?.accountInfoViewModel?.email
    }
    
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: sectionInsets.left, bottom: 8, right: sectionInsets.right)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.collectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCell.reuseID, for: indexPath) as! ClassCell
        
        let cellViewModel = homeViewModel?.collectionViewViewModel?.cellViewModel(for: indexPath)
       
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    
}

extension HomeViewController {
    
}
