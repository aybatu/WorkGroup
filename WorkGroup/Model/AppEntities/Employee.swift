//
//  Employee.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 13/07/2023.
//

import Foundation

class Employee: UserAccount {
    var accountType: AccountTypes
    var emailAddress: String
    var userFirstName: String
    var userLastName: String
    var password: String
    var userTasks: [Task]
    var employeeInvitedMeetings: [Meeting]
    let employeeTaskCapacity: Int = 10
    
    enum CodingKeys: String, CodingKey {
        case accountType
        case emailAddress
        case userFirstName
        case userLastName
        case password
        case userTasks
        case employeeInvitedMeetings
    }
    
    init(emailAddress: String, userFirstName: String, userLastName: String, password: String) {
        self.accountType = .EMPLOYEE
        self.emailAddress = emailAddress
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.password = password
        self.userTasks = []
        self.employeeInvitedMeetings = []
        
    }
    
    
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(emailAddress)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(emailAddress, forKey: .emailAddress)
        try container.encode(userFirstName, forKey: .userFirstName)
        try container.encode(userLastName, forKey: .userLastName)
        try container.encode(password, forKey: .password)
        try container.encode(userTasks, forKey: .userTasks)
        try container.encode(employeeInvitedMeetings, forKey: .employeeInvitedMeetings)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountType = try container.decode(AccountTypes.self, forKey: .accountType)
        emailAddress = try container.decode(String.self, forKey: .emailAddress)
        userFirstName = try container.decode(String.self, forKey: .userFirstName)
        userLastName = try container.decode(String.self, forKey: .userLastName)
        password = try container.decode(String.self, forKey: .password)
        userTasks = try container.decode([Task].self, forKey: .userTasks)
        employeeInvitedMeetings = try container.decode([Meeting].self, forKey: .employeeInvitedMeetings)
    }
    
    
    func changeAccountType(newAccountType: AccountTypes) {
        accountType = newAccountType
    }
    func changeName(newName: String) {
        userFirstName = newName
    }
    func changeLastName(newLastName: String) {
        userLastName = newLastName
    }
    func changeEmail(newEmail: String) {
        emailAddress = newEmail
    }
    func changePassword(newPassword: String) {
        password = newPassword
    }
    
    func checkEmployeeAvailablity(completion: @escaping(AssignNewTaskToEmployee) -> Void) {
        if userTasks.count < employeeTaskCapacity {
            completion(.available)
        } else {
            completion(.unavailable(message: "Employee already assigned for three different tasks. Please choose another emplyee."))
        }
    }
    
    func assignTask(task: Task) {
        userTasks.append(task)
    }
    
    func removeTask(task: Task) {
        if let taskIndex = userTasks.firstIndex(of: task) {
            userTasks.remove(at: taskIndex)
        }
    }
    func addMeeting(meeting: Meeting) {
        employeeInvitedMeetings.append(meeting)
    }
    func removeMeeting(meeting: Meeting) {
        employeeInvitedMeetings.removeAll { $0.meetingTitle == meeting.meetingTitle }
    }
    // Compare based on email address
    static func < (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.emailAddress < rhs.emailAddress
    }
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.emailAddress == rhs.emailAddress
    }
}
