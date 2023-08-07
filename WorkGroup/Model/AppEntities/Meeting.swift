//
//  Meeting.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 04/07/2023.
//

import Foundation

class Meeting: Hashable, Codable {
    var meetingDate: Date
    var meetingStartTime: Date
    var meetingEndTime: Date
    var meetingTitle: String
    var meetingDescription: String
    private let customDateFormat = "yyyy-MM-dd"
    private let customTimeFormat = "HH:mm"
    
    enum CodingKeys: String, CodingKey {
        case meetingDate
        case meetingStartTime
        case meetingEndTime
        case meetingTitle
        case meetingDescription
    }
    
    init(meetingDate: Date, meetingStartTime: Date, meetingEndTime: Date, meetingTitle: String, meetingDescription: String) {
        self.meetingDate = meetingDate
        self.meetingStartTime = meetingStartTime
        self.meetingEndTime = meetingEndTime
        self.meetingTitle = meetingTitle
        self.meetingDescription = meetingDescription
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(meetingTitle)
    }
    
    // Implement the encode(to:) method to encode the properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = customTimeFormat
        
        try container.encode(dateFormatter.string(from: meetingDate), forKey: .meetingDate)
        try container.encode(timeFormatter.string(from: meetingStartTime), forKey: .meetingStartTime)
        try container.encode(timeFormatter.string(from: meetingEndTime), forKey: .meetingEndTime)
        try container.encode(meetingTitle, forKey: .meetingTitle)
        try container.encode(meetingDescription, forKey: .meetingDescription)
    }
    
    // Implement the required initializer (init(from:)) to decode the properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = customTimeFormat
        
        if let meetingDateString = try? container.decode(String.self, forKey: .meetingDate),
           let meetingDate = dateFormatter.date(from: meetingDateString) {
            self.meetingDate = meetingDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .meetingDate, in: container, debugDescription: "Invalid date format")
        }
        
        if let meetingStartTimeString = try? container.decode(String.self, forKey: .meetingStartTime),
           let meetingStartTime = timeFormatter.date(from: meetingStartTimeString) {
            self.meetingStartTime = meetingStartTime
        } else {
            throw DecodingError.dataCorruptedError(forKey: .meetingStartTime, in: container, debugDescription: "Invalid time format")
        }
        
        if let meetingEndTimeString = try? container.decode(String.self, forKey: .meetingEndTime),
           let meetingEndTime = timeFormatter.date(from: meetingEndTimeString) {
            self.meetingEndTime = meetingEndTime
        } else {
            throw DecodingError.dataCorruptedError(forKey: .meetingEndTime, in: container, debugDescription: "Invalid time format")
        }
        
        meetingTitle = try container.decode(String.self, forKey: .meetingTitle)
        meetingDescription = try container.decode(String.self, forKey: .meetingDescription)
    }
    
    
    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        return lhs.meetingTitle == rhs.meetingTitle
    }
    
}
