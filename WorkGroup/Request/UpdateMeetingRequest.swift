//
//  UpdateMeetingRequest.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 05/08/2023.
//

import Foundation

struct UpdateMeetingRequest: Codable {
    var originalMeeting: Meeting
    var meeting: Meeting
    var invitedEmployeeList: [Employee]
}
