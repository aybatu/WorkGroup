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
    
    var registrationNumber: String {
        return String(_registrationNumber)
    }
    
    var userAccounts: [UserAccount] {
        return _userAccounts
    }
    
    let companyName: String
    
    init(companyName: String) {
        self.companyName = companyName
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
    
    static func < (lhs: RegisteredCompany, rhs: RegisteredCompany) -> Bool {
        return lhs.registrationNumber < rhs.registrationNumber
    }
    
    static func == (lhs: RegisteredCompany, rhs: RegisteredCompany) -> Bool {
        return lhs.registrationNumber == rhs.registrationNumber
    }
}
