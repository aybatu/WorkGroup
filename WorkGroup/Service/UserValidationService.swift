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
            if company?.ownerAccount.emailAddress == email  && company?.ownerAccount.password == password{
                let isValidUser = true
                let accountType: AccountTypes = .ADMIN
                let isValidCompany = true
                completion(isValidUser, isValidCompany, accountType)
            } else {
                let searchEmployeeAccount = Search<Employee>()
                let searchManagerAccounts = Search<Manager>()
                var foundUserAccount: (any UserAccount)?
                
                if let employeeAccounts = company?.employeeAccounts.sorted() {
                    let employeeAccount = searchEmployeeAccount.binarySearch(employeeAccounts, target: email, keyPath: \.emailAddress)
                    if let foundEmployeeAccount = employeeAccount {
                        foundUserAccount = foundEmployeeAccount
                    }
                }
                
                if let managerAccounts = company?.managerAccounts.sorted() {
                    let managerAccount = searchManagerAccounts.binarySearch(managerAccounts, target: email, keyPath: \.emailAddress)
                    if let foundManagerAccount = managerAccount {
                        foundUserAccount = foundManagerAccount
                    }
                    
                }
                    
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
