//
//  Meeting.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 04/07/2023.
//

import Foundation

class Meeting: Hashable {
    
    
    private var _meetingDate: Date
    private var _meetingStartTime: Date
    private var _meetingEndTime: Date
    private var _meetingTitle: String
    private var _meetingDescription: String

    
    var meetingDate: Date {
        return _meetingDate
    }
    var meetingStartTime: Date {
        return _meetingStartTime
    }
    var meetingEndTime: Date {
        return _meetingEndTime
    }
    var meetingTitle: String {
        return _meetingTitle
    }
    var meetingDescription: String {
        return _meetingDescription
    }
  
    
    init(_meetingDate: Date, _meetingStartTime: Date, _meetingEndTime: Date, _meetingTitle: String, _meetingDescription: String) {
        self._meetingDate = _meetingDate
        self._meetingStartTime = _meetingStartTime
        self._meetingEndTime = _meetingEndTime
        self._meetingTitle = _meetingTitle
        self._meetingDescription = _meetingDescription
     
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_meetingTitle)
    }
    
    func editMeetingDate(date: Date) {
        _meetingDate = date
    }
    func editMeetingStartTime(startTime: Date) {
        _meetingStartTime = startTime
    }
    func editMeetingEndTime(endTime: Date) {
        _meetingEndTime = endTime
    }
    func editMeetingTitle(meetingTitle: String) {
        _meetingTitle = meetingTitle
    }
    func editMeetingDescription(meetingDescription: String) {
        _meetingDescription = meetingDescription
    }
    
    
    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        return lhs._meetingTitle == rhs._meetingTitle
    }
}
