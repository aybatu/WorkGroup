//
//  Task.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Task: Hashable {
   
    
    private var _title: String
    private var _description: String
    private var _assignedEmployees: Set<UserAccount>
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
    var assignedEmployees: Set<UserAccount> {
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
    
    init(title: String, description: String, assignedEmployees: Set<UserAccount>, taskStartDate: Date, taskEndDate: Date) {
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
    
    func assignEmployee(employee: UserAccount, completion: @escaping(Bool, Bool, Bool) -> Void) {
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
    
    func editAssignedEmployees(employeeSet: Set<UserAccount>) {
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