//
//  CollectionViewViewModelType.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 10.03.2023.
//

import Foundation

protocol CollectionViewViewModelType: AnyObject {
    func querySubjects(name: String, surname: String, completion: @escaping () -> Void)
    func queryAttendance(name: String, surname: String, for subject: String, completion: @escaping (Int) -> Void)
    var totalAttendanceCount: Int {get set}
    var absenceCount: Int {get set}
    func numberOfRows() -> Int
    func selectRow(atIndextPath indexPath: IndexPath)
    func viewModelForSelectedRow() -> SubjectScheduleViewModelType?
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType?
}
