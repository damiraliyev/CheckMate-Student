//
//  CollectionViewViewModel.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

final class CollectionViewViewModel: CollectionViewViewModelType {
    
    var subjects: [Subject] = []
    
    private var selectedIndexPath: IndexPath?
    
    var totalAttendanceCount: Int = 0;
    var absenceCount: Int = 0;
    
//    private func getSubjects() -> [Subject] {
//        return subjects
//    }
    
    func setSubjectsForSkeletons() {
        let row = Subject.makeSkeleton()
        
        self.subjects = Array(repeating: row, count: 5)
    }
    
    func checkIfContains(name: String) -> Bool {
        var contains = false
        
        for i in 0..<subjects.count {
            if subjects[i].subjectName == name {
                contains = true
            }
        }
        
        return contains
    }
    
    func loadSubjectsInfo(completion: @escaping () -> Void) {
        DatabaseManager.shared.loadAttendance { [weak self] subjects in
            self?.subjects = subjects
            completion()
        }
    }
   
    
    func numberOfRows() -> Int {
        print(subjects.count)
        return subjects.count
    }
    
    func viewModelForSelectedRow() -> SubjectScheduleViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else {
            return nil
        }
        
        return SubjectScheduleViewModel(subject: subjects[selectedIndexPath.row])
    }
    
    
    func selectRow(atIndextPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType? {
        let subject = subjects[indexPath.row]
        
        return CollectionViewCellViewModel(subject: subject)
    }

    
    
}
