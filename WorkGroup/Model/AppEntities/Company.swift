//
//  RegisterCompany.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation

class Company: Comparable, Codable {
    
    
    var registrationNumber: String?
    var companyName: String
    var ownerAccount: Admin
    var employeeAccounts: [Employee]
    var managerAccounts: [Manager]
    var projects: [Project]
    var meetings: [Meeting]
    var searchKey: String {
        return registrationNumber ?? companyName
    }
    
    enum CodingKeys: String, CodingKey {
        case registrationNumber
        case companyName
        case ownerAccount
        case employeeAccounts
        case managerAccounts
        case projects
        case meetings
    }
    
    init(companyName: String, ownerAccount: Admin) {
        self.companyName = companyName
        self.ownerAccount = ownerAccount
        self.meetings = []
        self.projects = []
        self.employeeAccounts = []
        self.managerAccounts = []
    }
    
    // MARK: - User Account Management
    
    func addUserAccount(_ employeeAccount: Employee) {
        employeeAccounts.append(employeeAccount)
    }
    
    func removeUserAccount(_ employeeAccount: Employee) {
        if let index = employeeAccounts.firstIndex(of: employeeAccount) {
            employeeAccounts.remove(at: index)
        }
    }
    
    // MARK: - Project Management
    
    func addProject(_ project: Project, completion: @escaping (Bool) -> Void) {
        
        projects.append(project)
        completion(true)
    }
    
    // MARK: - Meeting Management
    
    func addMeeting(_ meeting: Meeting) {
        meetings.append(meeting)
    }
    
    // MARK: - Comparable
    
    static func < (lhs: Company, rhs: Company) -> Bool {
        return lhs.registrationNumber ?? lhs.companyName < rhs.registrationNumber ?? rhs.companyName
    }
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.registrationNumber == rhs.registrationNumber
    }
    
    // MARK: - Decodable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        registrationNumber = try container.decode(String.self, forKey: .registrationNumber)
        companyName = try container.decode(String.self, forKey: .companyName)
        ownerAccount = try container.decode(Admin.self, forKey: .ownerAccount)
        managerAccounts = try container.decode([Manager].self, forKey: .managerAccounts)
        employeeAccounts = try container.decode([Employee].self, forKey: .employeeAccounts)
        projects = try container.decode([Project].self, forKey: .projects)
        meetings = try container.decode([Meeting].self, forKey: .meetings)
        
    
    }
    
    // MARK: - Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(registrationNumber, forKey: .registrationNumber)
        try container.encode(companyName, forKey: .companyName)
        try container.encode(ownerAccount, forKey: .ownerAccount)
        try container.encode(employeeAccounts, forKey: .employeeAccounts)
        try container.encode(projects, forKey: .projects)
        try container.encode(meetings, forKey: .meetings)
    }
}
