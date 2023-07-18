//
//  AccountTypes.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 22/06/2023.
//

enum AccountTypes: String, Codable, CaseIterable {
    case MANAGER
    case EMPLOYEE
    case ADMIN

    static let allCases = [MANAGER, ADMIN, EMPLOYEE]
    static let employeeCases = [MANAGER, EMPLOYEE]
}
