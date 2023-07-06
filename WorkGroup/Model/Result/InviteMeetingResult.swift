//
//  InviteMeetingResult.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 05/07/2023.
//

import Foundation

enum InviteMeetingResult {
    case success
    case thereIsNoBreakTime(message: String)
    case employeeIsNotAvailable(message: String)
}
