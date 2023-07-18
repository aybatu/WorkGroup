//
//  UserValidationService.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/07/2023.
//

import Foundation

struct UserValidationService {
    func validateUser(company: Company?, email: String, password: String, completion: @escaping (Bool, Bool, AccountTypes?) -> Void) {
        
        if company == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let isValidUser = false
                let isValidCompany = false
                let accountType: AccountTypes? = nil
                completion(isValidUser, isValidCompany, accountType)
            }
        } else {
            if company?.ownerAccount.emailAddress == email {
                let isValidUser = true
                let accountType: AccountTypes = .ADMIN
                let isValidCompany = true
                completion(isValidUser, isValidCompany, accountType)
            } else {
                let searchUserAccount = Search<Employee>()
                if let userAccounts = company?.employeeAccounts.sorted() {
                    let foundUserAccount = searchUserAccount.binarySearch(userAccounts, target: email, keyPath: \.emailAddress)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        var isValidUser = false
                        var accountType: AccountTypes?
                        let isValidCompany = true
                        if let userAccount = foundUserAccount, userAccount.password == password {
                            isValidUser = true
                            
                            
                            switch userAccount.accountType {
                            case .ADMIN:
                                accountType = .ADMIN
                            case .MANAGER:
                                accountType = .MANAGER
                            case .EMPLOYEE:
                                accountType = .EMPLOYEE
                            }
                        }
                        
                        completion(isValidUser, isValidCompany, accountType)
                    }
                }
            }
        }
        
    }
}
