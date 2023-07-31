//
//  UserAccount.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation
protocol UserAccount: Codable, Comparable  {
    var accountType: AccountTypes { get }
    var emailAddress: String { get }
    var userFirstName: String { get }
    var userLastName: String { get }
    var password: String { get }
    // Common properties and methods...
}

extension UserAccount {
    func changeName(newName: String) {
        // Implementation for changing name...
    }
    
    func changeLastName(newLastName: String) {
        // Implementation for changing last name...
    }
    
    func changeEmail(newEmail: String) {
        // Implementation for changing email...
    }
    
    func changePassword(newPassword: String) {
        // Implementation for changing password...
    }
    func changeUserAccountType(newUserAccountType: AccountTypes) {
    }
}

