//
//  Task.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Task: Hashable {
   
    
    private var _name: String
    private var _description: String
    private var _assignedEmployees: Set<UserAccount>
    private var _taskEmployeeLimit = 5
    private var _isTaskCompleted: Bool
    
    var name: String {
        return _name
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
    
    init(name: String, description: String, assignedEmployees: Set<UserAccount>) {
        self._name = name
        self._description = description
        self._assignedEmployees = assignedEmployees
        self._isTaskCompleted = false
    }
    
    func hash(into hasher: inout Hasher) {
       
        hasher.combine(_name)
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
        self._isTaskCompleted = true
    }
    
    func revertTaskCompletion() {
        self._isTaskCompleted = false
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.name == rhs.name
    }
}
