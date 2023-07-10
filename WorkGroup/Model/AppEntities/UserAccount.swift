//
//  UserAccount.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation

class UserAccount: Comparable, Hashable {
    private var _accountType: AccountTypes
    private var _emailAddress: String
    private var _userFirstName: String
    private var _userLastName: String
    private var _password: String
    private var _userTasks: Set<Task>
    private var _employeeTaskCapacity = 10
    private var _employeeMeetings: [Meeting]
    
    var accountType: AccountTypes {
        return _accountType
    }
    var emailAddress: String {
        return _emailAddress
    }
    var userFirstName: String {
        return _userFirstName
    }
    var userLastName: String {
        return _userLastName
    }
    var password: String {
        return _password
    }
    var employeeTaskCapacity: Int {
        return _employeeTaskCapacity
    }
    var userTasks: Set<Task> {
        return _userTasks
    }
    var employeeMeetings: [Meeting] {
        return _employeeMeetings
    }
    
    init(accountType: AccountTypes, emailAddress: String, userFirstName: String, userLastName: String, password: String) {
        self._accountType = accountType
        self._emailAddress = emailAddress
        self._userFirstName = userFirstName
        self._userLastName = userLastName
        self._password = password
        self._userTasks = []
        self._employeeMeetings = []
    }
    
    func hash(into hasher: inout Hasher) {
       
        hasher.combine(emailAddress)
    }
    
    func changeName(newName: String) {
        _userFirstName = newName
    }
    func changeLastName(newLastName: String) {
        _userLastName = newLastName
    }
    func changeEmail(newEmail: String) {
        _emailAddress = newEmail
    }
    func changePassword(newPassword: String) {
        _password = newPassword
    }
    func changeAccountType(newAccountType: AccountTypes) {
        _accountType = newAccountType
    }
    func checkEmployeeAvailablity(completion: @escaping(AssignNewTaskToEmployee) -> Void) {
        if _userTasks.count < _employeeTaskCapacity {
            completion(.available)
        } else {
            completion(.unavailable(message: "Employee already assigned for three different tasks. Please choose another emplyee."))
        }
    }
    
    func assignTask(task: Task) {
        _userTasks.insert(task)
    }
    
    func removeTask(task: Task) {
        _userTasks.remove(task)
    }
    func addMeeting(meeting: Meeting) {
        _employeeMeetings.append(meeting)
    }
    func removeMeeting(meeting: Meeting) {
        _employeeMeetings.removeAll { $0.meetingTitle == meeting.meetingTitle }
    }
    // Compare based on email address
    static func < (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.emailAddress < rhs.emailAddress
    }
    
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.emailAddress == rhs.emailAddress
    }
}
