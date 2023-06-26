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
    
    init(accountType: AccountTypes, emailAddress: String, userFirstName: String, userLastName: String, password: String) {
        self._accountType = accountType
        self._emailAddress = emailAddress
        self._userFirstName = userFirstName
        self._userLastName = userLastName
        self._password = password
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
    // Compare based on email address
    static func < (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.emailAddress < rhs.emailAddress
    }
    
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.emailAddress == rhs.emailAddress
    }
}
