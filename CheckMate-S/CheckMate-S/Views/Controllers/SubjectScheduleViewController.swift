//
//  SubjectScheduleViewController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 17.03.2023.
//

import Foundation
import UIKit

@available(iOS 16.0, *)
final class SubjectScheduleViewController: UIViewController {
    
    private var collectionViewViewModel: ClassCollectionViewViewModelType?
    
    var subjectScheduleViewModel: SubjectScheduleViewModelType?
    
    let dateLabel = ViewFactory.makeLabel(fontSize: 18, color: .sduLightBlue, weight: .regular)
    
    let noClassesLabel = ViewFactory.makeLabel(fontSize: 19, color: .systemGray2, weight: .medium)
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
    let calendarView = UICalendarView()
    
    var selectedDate = String.date(from: Date()) ?? "1.1.1970"
    
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
        view.backgroundColor = .secondarySystemBackground
        
        setup()
        layout()
        
    }
    
    private func setup() {
        
        collectionViewViewModel = ClassCollectionViewViewModel()
        
        subjectScheduleViewModel?.classCollectionViewViewModel = collectionViewViewModel
        
        title = subjectScheduleViewModel?.subjectCodeWithoutDetail
        
        dateLabel.text = subjectScheduleViewModel?.dateText
        dateLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showOrHideCalendar))
        dateLabel.addGestureRecognizer(tapGesture)
        
        guard let subjectScheduleViewModel = subjectScheduleViewModel else {
            return
        }
        
        noClassesLabel.isHidden = true
        noClassesLabel.text = "There is no classes of \(subjectScheduleViewModel.subjectCodeWithoutDetail) for this date."
        noClassesLabel.numberOfLines = 0
        noClassesLabel.textAlignment = .center
        
        subjectScheduleViewModel.classCollectionViewViewModel?.queryClassForDate(
            studentID: UserDefaults.standard.value(forKey: "id") as? String ?? "",
            fullSubjectCode: subjectScheduleViewModel.fullSubjectCode,
            subjectCode: subjectScheduleViewModel.subjectCodeWithoutDetail,
            date: String.date(from: Date()) ?? "",
            completion: { [weak self] in
                self?.collectionView.reloadData()
                if self?.subjectScheduleViewModel?.classCollectionViewViewModel?.numberOfRows() == 0 {
                    self?.noClassesLabel.isHidden = false
                }
            })
        
        DatabaseManager.shared.getTokens(
            for: String.date(from: Date()) ?? "",
            fullCode: subjectScheduleViewModel.fullSubjectCode) { tokens in
                guard let tokens = tokens else { return }
                
                print(tokens)
            }
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ClassCell.self, forCellWithReuseIdentifier: ClassCell.reuseID)
        
        configureCalendarView()
 
//        subjectScheduleViewModel.loadAttendanceStatusesForDate()
        
    }
    
    @objc func showOrHideCalendar() {
        calendarView.isHidden = !calendarView.isHidden
    }
    
    private func layout() {
        view.addSubview(dateLabel)
        view.addSubview(collectionView)
        view.addSubview(noClassesLabel)
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noClassesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noClassesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 330)
        ])
    }
    
    func configureCalendarView() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.layer.cornerRadius = 10
        calendarView.clipsToBounds = true
        calendarView.backgroundColor = .white
        calendarView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.isHidden = true
    }

}

@available(iOS 16.0, *)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = subjectScheduleViewModel?.classCollectionViewViewModel else {
            return
        }
        
        viewModel.selectedIndexPath = indexPath
        
        guard let selectedClass: SubjectClass = viewModel.selectedClass() else {
            return
        }
        
        let alertController = UIAlertController(title: "Action", message: "Choose the action", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Check attendance", style: .default) { [weak self] _ in
            self?.checkAttendanceWithToken(viewModel: viewModel, selectedClass: selectedClass)
        })
        
        alertController.addAction(UIAlertAction(title: "Attach absence reason", style: .default) {[weak self] _ in
            let vc = MailComposerViewController()
            let mailViewModel = MailViewModel(
                selectedClass: selectedClass,
                date: self?.selectedDate ?? "1.1.1970"
            )
            vc.mailViewModel = mailViewModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true)
        

        
    }
    
    private func checkAttendanceWithToken(
        viewModel: ClassCollectionViewViewModelType,
        selectedClass: SubjectClass
    ) {
        viewModel.getTokensForClass(
            date: subjectScheduleViewModel?.dateText ?? "x",
            fullSubjectCode: selectedClass.fullSubjectCode) { [weak self] in
                let alertController = UIAlertController(title: "Check attendance", message: "Enter the token that teacher provided to you.", preferredStyle: .alert)
                alertController.addTextField()
                
                alertController.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
                    let enteredToken = alertController.textFields![0]
                    
                    viewModel.enteredToken = enteredToken.text
                    
                    if viewModel.checkToken(fullSubjectCode: selectedClass.fullSubjectCode) {
                        viewModel.updateAttendanceStatus(
                            date: self?.subjectScheduleViewModel?.dateText ?? "X",
                            studentID: UserDefaults.standard.value(forKey: "id") as? String ?? "",
                            fullSubjectCode: selectedClass.fullSubjectCode) { hasUpdated in
                                if hasUpdated {
                                    print("Attendance was successfully checked")
                                    self?.showResultAlert(isSuccessfull: true)
                                    self?.collectionView.reloadData()
                                } else {
                                    self?.showResultAlert(isSuccessfull: false)
                                    print("Attendance was not checked")
                                }
                            }
                    } else {
                        self?.showResultAlert(isSuccessfull: false)
                    }
                    
                })
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self?.present(alertController, animated: true)
            }
        
    }
    
    private func showResultAlert(isSuccessfull: Bool) {
        
        guard let viewModel = subjectScheduleViewModel?.classCollectionViewViewModel else {
            return
        }
        
        let alerController = UIAlertController(title: "Success!", message: "Your attendance has been checked.", preferredStyle: .alert)
        alerController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if !isSuccessfull {
            alerController.title = "Failure."
            
            if !viewModel.isValidToken {
                alerController.message = "Invalid token."
            } else {
                alerController.message = "Fail to check your attendance."
            }
            
        }
        present(alerController, animated: true)
    }
    
}


@available(iOS 16.0, *)
extension SubjectScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCell.reuseID, for: indexPath) as! ClassCell
        
        let cellViewModel = subjectScheduleViewModel?.classCollectionViewViewModel?.classCellViewModel(for: indexPath)
        
//        cell.configure(viewModel: cellViewModel)
        cell.viewModel = cellViewModel
        
        
        
        return cell;
    }
    
    
}

@available(iOS 16.0, *)
extension SubjectScheduleViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard var subjectScheduleViewModel = subjectScheduleViewModel else { return }
        selectedDate = subjectScheduleViewModel.convertDate(
            day: dateComponents?.day,
            month: dateComponents?.month,
            year: dateComponents?.year
        )
        
        subjectScheduleViewModel.dateText = selectedDate
        
        print("BEFOR LOADING ATTENDANCE STATUSES", subjectScheduleViewModel.dateText)
//        subjectScheduleViewModel.loadAttendanceStatusesForDate()
        
        subjectScheduleViewModel.classCollectionViewViewModel?.queryClassForDate(
            studentID: UserDefaults.standard.value(forKey: "id") as? String ?? "",
            fullSubjectCode: subjectScheduleViewModel.fullSubjectCode,
            subjectCode: subjectScheduleViewModel.subjectCodeWithoutDetail,
            date: selectedDate,
            completion: { [weak self] in
                self?.dateLabel.text = self?.selectedDate
                self?.collectionView.reloadData()
                
                if self?.subjectScheduleViewModel?.classCollectionViewViewModel?.numberOfRows() == 0 {
                    self?.noClassesLabel.isHidden = false
                } else {
                    self?.noClassesLabel.isHidden = true
                }
            })
        
        DatabaseManager.shared.getTokens(
            for: selectedDate,
            fullCode: subjectScheduleViewModel.fullSubjectCode) { tokens in
               
                guard let tokens = tokens else {
                    print("NO TOKENS")
                    print("getTokens fullCode \(subjectScheduleViewModel.fullSubjectCode)")
                    return
                }
                
                print("TOKENS", tokens)
            }
        
        
        showOrHideCalendar()
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
}
