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
     var finishDate: Date
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case tasks
        case startDate
        case finishDate
    }
   
    
    init(title: String, description: String, tasks: [Task], startDate: Date, finishDate: Date) {
        self.title = title
        self.description = description
        self.tasks = tasks
        self.startDate = startDate
        self.finishDate = finishDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        tasks = try container.decode([Task].self, forKey: .tasks)
        startDate = try container.decode(Date.self, forKey: .startDate)
        finishDate = try container.decode(Date.self, forKey: .finishDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(finishDate, forKey: .finishDate)
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
        finishDate = newEndDate
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
