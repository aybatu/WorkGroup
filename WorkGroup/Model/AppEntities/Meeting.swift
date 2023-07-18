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
        try container.encode(meetingDate, forKey: .meetingDate)
        try container.encode(meetingStartTime, forKey: .meetingStartTime)
        try container.encode(meetingEndTime, forKey: .meetingEndTime)
        try container.encode(meetingTitle, forKey: .meetingTitle)
        try container.encode(meetingDescription, forKey: .meetingDescription)
    }
    
    // Implement the required initializer (init(from:)) to decode the properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meetingDate = try container.decode(Date.self, forKey: .meetingDate)
        meetingStartTime = try container.decode(Date.self, forKey: .meetingStartTime)
        meetingEndTime = try container.decode(Date.self, forKey: .meetingEndTime)
        meetingTitle = try container.decode(String.self, forKey: .meetingTitle)
        meetingDescription = try container.decode(String.self, forKey: .meetingDescription)
    }
    
    // Other methods and properties...
    
    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        return lhs.meetingTitle == rhs.meetingTitle
    }
}
