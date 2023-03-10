import UIKit

struct Student {
    let id: String
    let name: String
    let surname: String
    let email: String
    let courses: [Course]
    let attendance_records: [Course: [AttendanceRecord]]
    
}

struct Course: Hashable, Equatable {
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let name: String
    let schedule: Schedule
    
}

struct Classroom {
    let id: String
    let name: String
}

struct AttendanceRecord {
    let id: String
    let date: String
    let isPresent: Bool
    let reasonForAbsence: String
}

struct Schedule: Hashable {
    let dayOfWeek: String
    let date: String
    let start_time: String
    let end_time: String
    let classroomID : String
}

struct Holidays {
    
}

struct Teacher {
    let id: String
    let name: String
    let surname: String
    let courses: [Course]
    let schedule: [Course: Schedule]
}

let schedule = Schedule(dayOfWeek: "Monday", date: "7.03.2023", start_time: "13:00", end_time: "13:50", classroomID: "F104")

let softwareEngineering = Course(id: "CSS 342", name: "Software Engineering", schedule: schedule)

let attendanceRecord = AttendanceRecord(id: "1", date: "7.03.2023", isPresent: true, reasonForAbsence: "")

let attRecord = [softwareEngineering: [attendanceRecord]]

let student = Student(id: "200107116", name: "Damir", surname: "Aliyev", email: "200107116@stu.sdu.edu.kz", courses: [softwareEngineering], attendance_records: attRecord)


print(student.courses)
