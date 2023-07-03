//
//  Project.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Project: Comparable, Hashable {
 
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
    
}
