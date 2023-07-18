//
//  Task.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Task: Codable, Hashable {
   
    
    private var _title: String
    private var _description: String
    private var _assignedEmployees: Set<Employee>
    private var _taskEmployeeLimit = 5
    private var _isTaskCompleted: Bool
    private var _taskStartDate: Date
    private var _taskEndDate: Date
    
    var title: String {
        return _title
    }
    var description: String {
        return _description
    }
    var assignedEmployees: Set<Employee> {
        return _assignedEmployees
    }
    var taskEmployeeLimit: Int {
        return _taskEmployeeLimit
    }
    var isTaskCompleted: Bool {
        return _isTaskCompleted
    }
    var taskStartDate: Date {
        return _taskStartDate
    }
    var taskEndDate: Date {
        return _taskEndDate
    }
    
    enum CodingKeys: String, CodingKey {
           case title = "_title"
           case description = "_description"
           case assignedEmployees = "_assignedEmployees"
           case taskEmployeeLimit = "_taskEmployeeLimit"
           case isTaskCompleted = "_isTaskCompleted"
           case taskStartDate = "_taskStartDate"
           case taskEndDate = "_taskEndDate"
       }
    
    init(title: String, description: String, assignedEmployees: Set<Employee>, taskStartDate: Date, taskEndDate: Date) {
        self._title = title
        self._description = description
        self._assignedEmployees = assignedEmployees
        self._isTaskCompleted = false
        self._taskStartDate = taskStartDate
        self._taskEndDate = taskEndDate
    }
    
    func hash(into hasher: inout Hasher) {
       
        hasher.combine(_title)
    }
    
    func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(_title, forKey: .title)
         try container.encode(_description, forKey: .description)
         try container.encode(_assignedEmployees, forKey: .assignedEmployees)
         try container.encode(_taskEmployeeLimit, forKey: .taskEmployeeLimit)
         try container.encode(_isTaskCompleted, forKey: .isTaskCompleted)
         try container.encode(_taskStartDate, forKey: .taskStartDate)
         try container.encode(_taskEndDate, forKey: .taskEndDate)
     }

     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         _title = try container.decode(String.self, forKey: .title)
         _description = try container.decode(String.self, forKey: .description)
         _assignedEmployees = try container.decode(Set<Employee>.self, forKey: .assignedEmployees)
         _taskEmployeeLimit = try container.decode(Int.self, forKey: .taskEmployeeLimit)
         _isTaskCompleted = try container.decode(Bool.self, forKey: .isTaskCompleted)
         _taskStartDate = try container.decode(Date.self, forKey: .taskStartDate)
         _taskEndDate = try container.decode(Date.self, forKey: .taskEndDate)
     }
    
    func assignEmployee(employee: Employee, completion: @escaping(Bool, Bool, Bool) -> Void) {
        var isTaskCapacity = false
        var isEmployeeAvailable = false
        var isTaskNewForEmployee = false
        if self._assignedEmployees.count <= _taskEmployeeLimit {
            isTaskCapacity = true
            completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
            if employee.userTasks.count < employee.employeeTaskCapacity {
                isEmployeeAvailable = true
                completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
                let (inserted, _) = self._assignedEmployees.insert(employee)
                if inserted {
                    isTaskNewForEmployee = true
                    completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
                }
            }
            
        }
        completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
    }
    
    func completeTask() {
        _isTaskCompleted = true
    }
    
    func editTaskTitle(title: String) {
        _title = title
    }
    
    func editTaskDescription(description: String) {
        _description = description
    }
    
    func editAssignedEmployees(employeeSet: Set<Employee>) {
        _assignedEmployees = employeeSet
    }
    
    func editStartDate(startDate: Date) {
        _taskStartDate = startDate
    }
    
    func editEndDate(endDate: Date) {
        _taskEndDate = endDate
    }
    
    func revertTaskCompletion() {
        _isTaskCompleted = false
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title
    }
}
