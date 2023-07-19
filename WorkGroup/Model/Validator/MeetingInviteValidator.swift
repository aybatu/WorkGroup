//
//  MeetingInviteValidator.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 05/07/2023.
//

import Foundation

struct MeetingInviteValidator {
    func isEmployeeAvailable(meetingDate: Date, meetingStartTime: Date, employee: Employee, completion: @escaping(InviteMeetingResult) -> Void) {
        // Check for any existing meetings for the employee that overlap with the new meeting
        for existingMeeting in employee.employeeInvitedMeetings {
            if existingMeeting.meetingDate == meetingDate {
                let breakTime = meetingStartTime.timeIntervalSince(existingMeeting.meetingEndTime)
                // Check for overlap
                if existingMeeting.meetingEndTime > meetingStartTime {
                    // There is an overlap, employee is not available
                    completion(.employeeIsNotAvailable(message: "Employee has another scheduled meeting in specified times."))
                    return
                } else if breakTime < 15 * 60 { // Convert 15 minutes to seconds
                    // Break time is less than 15 minutes, employee is not available
                    completion(.thereIsNoBreakTime(message: "Between the meetings there must be a 15mins break time for the employee."))
                    return
                }
            }
        }
        
        
        // Employee is available
        completion(.success)
        return
    }
}
