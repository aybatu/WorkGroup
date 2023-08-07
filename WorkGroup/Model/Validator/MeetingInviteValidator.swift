//
//  MeetingInviteValidator.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 05/07/2023.
//

import Foundation

struct MeetingInviteValidator {
    func isEmployeeAvailable(meetingDate: Date, meetingStartTime: Date, employee: Employee, completion: @escaping(InviteMeetingResult) -> Void) {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"


            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"

            // Format the meeting date and start time
            let formattedMeetingDate = dateFormatter.string(from: meetingDate)
            let formattedMeetingStartTime = timeFormatter.string(from: meetingStartTime)

            // Convert the formatted date string to a Date object
            if let meetingDate = dateFormatter.date(from: formattedMeetingDate) {
                // Convert the formatted time string to a Date object
                if let meetingStartTime = timeFormatter.date(from: formattedMeetingStartTime) {
                    // Check for any existing meetings for the employee that overlap with the new meeting
                    for existingMeeting in employee.employeeInvitedMeetings {
                        let existingMeetingFormattedDate = dateFormatter.string(from: existingMeeting.meetingDate)
                        let existingMeetingFormattedStartTime = timeFormatter.string(from: existingMeeting.meetingStartTime)
                        let existingMeetingFormattedEndTime = timeFormatter.string(from: existingMeeting.meetingEndTime)

                        if existingMeetingFormattedDate == formattedMeetingDate {
                            let breakTime = meetingStartTime.timeIntervalSince(existingMeeting.meetingEndTime)

                            // Check for overlap
                            if existingMeetingFormattedEndTime > formattedMeetingStartTime {
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
                }
            }

            // Employee is available
            completion(.success)
    }
}
