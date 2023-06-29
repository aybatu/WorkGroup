//
//  Project.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Project: Comparable, Hashable {
 
    private var _name: String
    private var _description: String
    private var _tasks: Set<Task>
    private var _startDate: Date
    private var _finishDate: Date
    
    var name: String {
        return _name
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
    
    init(name: String, description: String, tasks: Set<Task>, startDate: Date, finishDate: Date) {
        self._name = name
        self._description = description
        self._tasks = tasks
        self._startDate = startDate
        self._finishDate = finishDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_name)
    }
    
    func addTask(task: Task, completion: @escaping(Bool) -> Void) {
        let (inserted, _) = self._tasks.insert(task)
        
        completion(inserted)
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs._name == rhs._name
    }
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs._name < rhs._name
    }
    
}
