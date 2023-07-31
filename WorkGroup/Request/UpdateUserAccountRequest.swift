//
//  UpdateUserAccountRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 28/07/2023.
//

import Foundation
struct UpdateUserAccountRequest: Codable {
    let originalEmailAddress: String
    let newAccountType: AccountTypes
    let newEmailAddress: String
    let newUserFirstName: String
    let newUserLastName: String
    let newPassword: String
    let originalAccountType: AccountTypes
}
