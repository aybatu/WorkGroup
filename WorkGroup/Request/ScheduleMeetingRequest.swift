//
//  ScheduleMeetingRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 04/08/2023.
//

import Foundation

struct ScheduleMeetingRequest: Codable {
    var meeting: Meeting
    var invitedEmployeeList: [Employee]
}
