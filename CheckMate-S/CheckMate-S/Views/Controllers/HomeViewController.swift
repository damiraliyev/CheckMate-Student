//
//  HomeViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 04.03.2023.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController {
    
//    private var collectionViewViewModel: CollectionViewViewModelType?
    
    private var homeViewModel: HomeViewModelType?
    
    let appNameLabel = ViewFactory.makeLabel(
        fontSize: 24,
        color: UIColor.sduBlue,
        weight: .bold,
        text: "CheckMate"
    )
    
    let signOutButton = UIButton()
    
    let accountInfoView = AccountInfoView()
    
    let myClassesLabel = ViewFactory.makeLabel(fontSize: 28, weight: .semibold, text: "My Classes")
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        
        let collectionViewViewModel = CollectionViewViewModel()
        
        //Getting from UserDefaults
        let accountInfoViewModel = AccountInfoViewModel(
            student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                             surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                             email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
        )
        
        homeViewModel = HomeViewModel(collectionViewViewModel: collectionViewViewModel, accountInfoViewModel: accountInfoViewModel)
        
        
        homeViewModel?.collectionViewViewModel?.querySubjects(
            name: "Damir",
            surname: "Aliyev",
            completion: { [weak self] in
                print("Reload please")
                self?.collectionView.reloadData()
            })
//
//        homeViewModel?.collectionViewViewModel?.queryAttendance(name: "Damir", surname: "Aliyev", for: "CSS342",completion: { [weak self] in
//            print("SUCCESSFULL")
//            print("Attendance count", self?.homeViewModel?.collectionViewViewModel?.totalAttendanceCount)
//            print("Attendance count", self?.homeViewModel?.collectionViewViewModel?.absenceCount)
//            self?.collectionView.reloadData()
//        })
//
//        homeViewModel?.collectionViewViewModel?.queryAttendance(name: "Damir", surname: "Aliyev", for: "CSS358",completion: { [weak self] in
//            print("SUCCESSFULL")
//            print("Attendance count", self?.homeViewModel?.collectionViewViewModel?.totalAttendanceCount)
//            print("Attendance count", self?.homeViewModel?.collectionViewViewModel?.absenceCount)
//            self?.collectionView.reloadData()
//        })
        
        setup()
        addAllSubViews()
        layout()
    }
    
    private func setup() {
        accountInfoView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(SubjectCell.self, forCellWithReuseIdentifier: SubjectCell.reuseID)
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        signOutButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        signOutButton.tintColor = UIColor.sduBlue
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .primaryActionTriggered)
        
        setupInfo()
        
        let db = DB()
        
        db.attendanceCourseStudentIDValue()
        
        testQuery()
    }
    
    private func addAllSubViews() {
        view.addSubview(appNameLabel)
        view.addSubview(signOutButton)
        view.addSubview(accountInfoView)
        view.addSubview(myClassesLabel)
        view.addSubview(collectionView)
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo: appNameLabel.centerYAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            accountInfoView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 16),
            accountInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            accountInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            accountInfoView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 9)
        ])
        
        NSLayoutConstraint.activate([
            myClassesLabel.topAnchor.constraint(equalTo: accountInfoView.bottomAnchor, constant: 24),
            myClassesLabel.leadingAnchor.constraint(equalTo: accountInfoView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: myClassesLabel.bottomAnchor, constant: 16),
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
        
        let itemsPerRow: CGFloat = 1
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: view.frame.height / 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: sectionInsets.left, bottom: 15, right: sectionInsets.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
    
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = SubjectScheduleViewController()
        homeViewModel?.collectionViewViewModel?.selectRow(atIndextPath: indexPath)
        vc.subjectScheduleViewModel = homeViewModel?.collectionViewViewModel?.viewModelForSelectedRow()
        self.navigationController?.pushViewController(vc, animated: true)
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.collectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.reuseID, for: indexPath) as! SubjectCell
        
        let cellViewModel = homeViewModel?.collectionViewViewModel?.cellViewModel(for: indexPath)
       
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    
}




//MARK: - ACTIONS

extension HomeViewController {
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign out", message: "Are you sure?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        
        present(actionSheet, animated: true)
    }
}
