//
//  Admin.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 13/07/2023.
//

import Foundation

class Admin: UserAccount {
    var accountType: AccountTypes
    var emailAddress: String
    var userFirstName: String
    var userLastName: String
    var password: String
    
        
        enum CodingKeys: String, CodingKey {
            case accountType
            case emailAddress
            case userFirstName
            case userLastName
            case password
        }
        
     init(accountType: AccountTypes, emailAddress: String, userFirstName: String, userLastName: String, password: String) {
            self.accountType = accountType
            self.emailAddress = emailAddress
            self.userFirstName = userFirstName
            self.userLastName = userLastName
            self.password = password
        }
        
        // Hashable protocol methods...
        
        
    
    
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
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountType = try container.decode(AccountTypes.self, forKey: .accountType)
        emailAddress = try container.decode(String.self, forKey: .emailAddress)
        userFirstName = try container.decode(String.self, forKey: .userFirstName)
        userLastName = try container.decode(String.self, forKey: .userLastName)
        password = try container.decode(String.self, forKey: .password)
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
 
 
    static func < (lhs: Admin, rhs: Admin) -> Bool {
           return lhs.emailAddress < rhs.emailAddress
       }
       
       static func == (lhs: Admin, rhs: Admin) -> Bool {
           return lhs.emailAddress == rhs.emailAddress
       }
}
