//
//  Project.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Project: Comparable, Codable {
    
    var title: String
    var description: String
    var tasks: [Task]
    var startDate: Date
    var endDate: Date
    
    private let customDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case tasks
        case startDate
        case endDate
    }
    
    
    init(title: String, description: String, tasks: [Task], startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.tasks = tasks
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    
    // ... your existing code ...
    
    // MARK: - Codable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        tasks = try container.decode([Task].self, forKey: .tasks)
        
        // Decode dates using the custom date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        
        if let startDateString = try? container.decode(String.self, forKey: .startDate),
           let startDate = dateFormatter.date(from: startDateString) {
            self.startDate = startDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .startDate, in: container, debugDescription: "Invalid date format")
        }
        
        if let endDateString = try? container.decode(String.self, forKey: .endDate),
           let endDate = dateFormatter.date(from: endDateString) {
            self.endDate = endDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .endDate, in: container, debugDescription: "Invalid date format")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(tasks, forKey: .tasks)
        
        // Encode dates using the custom date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        try container.encode(dateFormatter.string(from: startDate), forKey: .startDate)
        try container.encode(dateFormatter.string(from: endDate), forKey: .endDate)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    func addTask(task: Task) {
        self.tasks.append(task)    }
    
    func editStartDate(newStartDate: Date) {
        startDate = newStartDate
    }
    
    func editEndDate(newEndDate: Date) {
        endDate = newEndDate
    }
    
    func editTitle(newTitle: String) {
        title = newTitle
    }
    
    func editDecription(newDescription: String) {
        description = newDescription
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.title == rhs.title
    }
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs.title < rhs.title
    }

}
