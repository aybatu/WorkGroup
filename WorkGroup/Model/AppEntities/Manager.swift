//
//  Manager.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/07/2023.
//

import Foundation

class Manager: UserAccount {
    var accountType: AccountTypes
    var emailAddress: String
    var userFirstName: String
    var userLastName: String
    var password: String
    var managerMeetings: [Meeting]
    
    enum CodingKeys: String, CodingKey {
        case accountType
        case emailAddress
        case userFirstName
        case userLastName
        case password
        case userTasks
        case managerMeetings
    }
    
    init(emailAddress: String, userFirstName: String, userLastName: String, password: String) {
        self.accountType = .MANAGER
        self.emailAddress = emailAddress
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.password = password
        self.managerMeetings = []
    }
    
    
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(emailAddress)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountType.rawValue, forKey: .accountType)
        try container.encode(emailAddress, forKey: .emailAddress)
        try container.encode(userFirstName, forKey: .userFirstName)
        try container.encode(userLastName, forKey: .userLastName)
        try container.encode(password, forKey: .password)
        try container.encode(managerMeetings, forKey: .managerMeetings)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountType = try container.decode(AccountTypes.self, forKey: .accountType)
        emailAddress = try container.decode(String.self, forKey: .emailAddress)
        userFirstName = try container.decode(String.self, forKey: .userFirstName)
        userLastName = try container.decode(String.self, forKey: .userLastName)
        password = try container.decode(String.self, forKey: .password)
        managerMeetings = try container.decode([Meeting].self, forKey: .managerMeetings)
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
    func changeAccountType(newAccountType: AccountTypes) {
        accountType = newAccountType
    }
    
//    func addMeeting(meeting: Meeting) {
//        managerMeetings.append(meeting)
//    }
//    func removeMeeting(meeting: Meeting) {
//        employeeMeetings.removeAll { $0.meetingTitle == meeting.meetingTitle }
//    }
    // Compare based on email address
    static func < (lhs: Manager, rhs: Manager) -> Bool {
        return lhs.emailAddress < rhs.emailAddress
    }
    
    static func == (lhs: Manager, rhs: Manager) -> Bool {
        return lhs.emailAddress == rhs.emailAddress
    }
    
    
}
