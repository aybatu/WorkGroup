//
//  Project.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Project: Comparable, Hashable, Codable {
    
    private var _title: String
    private var _description: String
    private var _tasks: Set<Task>
    private var _startDate: Date
    private var _finishDate: Date
    
    var title: String {
        return _title
    }
    var description: String {
        return _description
    }
    var tasks: Set<Task> {
        return _tasks
    }
    var startDate: Date {
        return _startDate
    }
    var finishDate: Date {
        return _finishDate
    }
    
    init(title: String, description: String, tasks: Set<Task>, startDate: Date, finishDate: Date) {
        self._title = title
        self._description = description
        self._tasks = tasks
        self._startDate = startDate
        self._finishDate = finishDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_title)
    }
    
    func addTask(task: Task, completion: @escaping(Bool) -> Void) {
        let (inserted, _) = self._tasks.insert(task)
        
        completion(inserted)
    }
    
    func editStartDate(startDate: Date) {
        _startDate = startDate
    }
    
    func editEndDate(endDate: Date) {
        _finishDate = endDate
    }
    
    func editTitle(title: String) {
        _title = title
    }
    
    func editDecription(description: String) {
        _description = description
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs._title == rhs._title
    }
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs._title < rhs._title
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case tasks
        case startDate
        case finishDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_title, forKey: .title)
        try container.encode(_description, forKey: .description)
        try container.encode(_tasks, forKey: .tasks)
        try container.encode(_startDate, forKey: .startDate)
        try container.encode(_finishDate, forKey: .finishDate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _title = try container.decode(String.self, forKey: .title)
        _description = try container.decode(String.self, forKey: .description)
        _tasks = try container.decode(Set<Task>.self, forKey: .tasks)
        _startDate = try container.decode(Date.self, forKey: .startDate)
        _finishDate = try container.decode(Date.self, forKey: .finishDate)
    }
}
