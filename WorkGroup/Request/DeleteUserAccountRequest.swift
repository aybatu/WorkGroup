//
//  DeleteUserAccountRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 28/07/2023.
//

import Foundation
struct DeleteUserAccountRequest: Codable {
    let accountType: AccountTypes
    let emailAddress: String
    let userFirstName: String
    let userLastName: String
    let password: String
}
