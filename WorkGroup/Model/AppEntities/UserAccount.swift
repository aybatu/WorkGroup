//
//  UserAccount.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

import Foundation

class UserAccount: Comparable {
    let accountType: AccountTypes
    let emailAddress: String
    let userFirstName: String
    let userLastName: String
    let password: String
    
    init(accountType: AccountTypes, emailAddress: String, userFirstName: String, userLastName: String, password: String) {
        self.accountType = accountType
        self.emailAddress = emailAddress
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.password = password
    }
    
    // Compare based on email address
    static func < (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.emailAddress < rhs.emailAddress
    }
    
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.emailAddress == rhs.emailAddress
    }
}
