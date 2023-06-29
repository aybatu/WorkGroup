//
//  RegisterCompany.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation

class RegisteredCompany: Comparable {
    
    private static var nextRegistrationNumber = 1
    private var _registrationNumber: Int
    private var _userAccounts: [UserAccount]
    private var _ownerAccount: UserAccount
    private var _projects: Set<Project> = []
    var registrationNumber: String {
        return String(_registrationNumber)
    }
    
    var userAccounts: [UserAccount] {
        return _userAccounts
    }
    var ownerAccount: UserAccount {
        return _ownerAccount
    }
    var projects: Set<Project> {
        return _projects
    }
    let companyName: String
    
    init(companyName: String, ownerAccount: UserAccount) {
        self.companyName = companyName
        self._ownerAccount = ownerAccount
        self._registrationNumber = RegisteredCompany.nextRegistrationNumber
        self._userAccounts = []
        RegisteredCompany.nextRegistrationNumber += 1
    }
    
    func addUserAccount(_ userAccount: UserAccount) {
        _userAccounts.append(userAccount)
    }
    
    func removeUserAccount(_ userAccount: UserAccount) {
        if let index = _userAccounts.firstIndex(of: userAccount) {
            _userAccounts.remove(at: index)
        }
    }
    
    func addProject(project: Project, completion: @escaping(Bool) -> Void) {
        let (inserted, _) = _projects.insert(project)
        
        completion(inserted)
    }
    
    static func < (lhs: RegisteredCompany, rhs: RegisteredCompany) -> Bool {
        return lhs._registrationNumber < rhs._registrationNumber
    }
    
    static func == (lhs: RegisteredCompany, rhs: RegisteredCompany) -> Bool {
        return lhs._registrationNumber == rhs._registrationNumber
    }
}
