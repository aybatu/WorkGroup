//
//  UserAccountRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 17/07/2023.
//

import Foundation

struct CreateUserAccountRequest: Codable {
    let accountType: AccountTypes
    let emailAddress: String
    let userFirstName: String
    let userLastName: String
    let password: String
}
