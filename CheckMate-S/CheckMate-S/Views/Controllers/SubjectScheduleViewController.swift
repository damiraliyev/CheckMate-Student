//
//  SubjectScheduleViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 17.03.2023.
//

import Foundation
import UIKit

class SubjectScheduleViewController: UIViewController {
    
    private var collectionViewViewModel: ClassCollectionViewViewModelType?
    
    var subjectScheduleViewModel: SubjectScheduleViewModelType?
    
    let dateLabel = makeLabel(fontSize: 18, color: .sduLightBlue, weight: .regular)
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
//    let calendarView = UICalendarView()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "CSS 342"
        view.backgroundColor = .secondarySystemBackground
        
        
//        collectionViewViewModel?.queryClassForDate(subjectCode: "CSS309[03-P]", date: "27.03.2023", completion: { [weak self] in
//            self?.collectionView.reloadData()
//        })
        setup()
        layout()
    }
    
    private func setup() {
        
        collectionViewViewModel = ClassCollectionViewViewModel()
        
        subjectScheduleViewModel?.classCollectionViewViewModel = collectionViewViewModel
        
        title = subjectScheduleViewModel?.subjectCodeWithoutDetail
        
        dateLabel.text = subjectScheduleViewModel?.dateText
        dateLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCalendar))
        dateLabel.addGestureRecognizer(tapGesture)
        
        guard let subjectScheduleViewModel = subjectScheduleViewModel else {
            return
        }

        
        subjectScheduleViewModel.classCollectionViewViewModel?.queryClassForDate(
            subjectCode: subjectScheduleViewModel.subjectCodeWithoutDetail,
            date: String.date(from: Date()) ?? "",
            completion: { [weak self] in
            
            self?.collectionView.reloadData()
        })
        
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ClassCell.self, forCellWithReuseIdentifier: ClassCell.reuseID)
        
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBack))
        
    }
    
    @objc func showCalendar() {
        
    }
    
    private func layout() {
        view.addSubview(dateLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func didTapBack() {
        self.dismiss(animated: true)
    }
    
    
}

extension SubjectScheduleViewController: UICollectionViewDelegateFlowLayout {
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
        return 14
    }
}


extension SubjectScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCell.reuseID, for: indexPath) as! ClassCell
        
        let cellViewModel = collectionViewViewModel?.classCellViewModel(for: indexPath)
        
//        cell.configure(viewModel: cellViewModel)
        cell.viewModel = cellViewModel
        
        return cell;
    }
    
    
}
