//
//  Task.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Task: Codable, Comparable {
   
    var title: String
    var description: String
    var assignedEmployees: [Employee]
    var taskEmployeeLimit = 5
    var isTaskCompleted: Bool
    var taskStartDate: Date
    var taskEndDate: Date
   
    
    enum CodingKeys: String, CodingKey {
           case title
           case description
           case assignedEmployees
           case isTaskCompleted
           case taskStartDate
           case taskEndDate
       }
    
    init(title: String, description: String, assignedEmployees: [Employee], taskStartDate: Date, taskEndDate: Date) {
        self.title = title
        self.description = description
        self.assignedEmployees = assignedEmployees
        self.isTaskCompleted = false
        self.taskStartDate = taskStartDate
        self.taskEndDate = taskEndDate
    }
    
    
    func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(title, forKey: .title)
         try container.encode(description, forKey: .description)
         try container.encode(assignedEmployees, forKey: .assignedEmployees)
        
         try container.encode(isTaskCompleted, forKey: .isTaskCompleted)
         try container.encode(taskStartDate, forKey: .taskStartDate)
         try container.encode(taskEndDate, forKey: .taskEndDate)
     }

     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         title = try container.decode(String.self, forKey: .title)
         description = try container.decode(String.self, forKey: .description)
         assignedEmployees = try container.decode([Employee].self, forKey: .assignedEmployees)
         
         isTaskCompleted = try container.decode(Bool.self, forKey: .isTaskCompleted)
         taskStartDate = try container.decode(Date.self, forKey: .taskStartDate)
         taskEndDate = try container.decode(Date.self, forKey: .taskEndDate)
     }
    
    func assignEmployee(employee: Employee, completion: @escaping(Bool, Bool, Bool) -> Void) {
        var isTaskCapacity = false
        var isEmployeeAvailable = false
        var isTaskNewForEmployee = false
        if assignedEmployees.count <= taskEmployeeLimit {
            isTaskCapacity = true
            completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
            if employee.userTasks.count < employee.employeeTaskCapacity {
                isEmployeeAvailable = true
                isTaskNewForEmployee = true
                completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
                assignedEmployees.append(employee)
                 
                    completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
                
            }
            
        }
        completion(isTaskCapacity, isEmployeeAvailable, isTaskNewForEmployee)
    }
    
    func completeTask() {
        isTaskCompleted = true
    }
    
    func editTaskTitle(newTitle: String) {
        title = newTitle
    }
    
    func editTaskDescription(newDescription: String) {
        description = newDescription
    }
    
    func editAssignedEmployees(employees: [Employee]) {
        assignedEmployees = employees
    }
    
    func editStartDate(startDate: Date) {
        taskStartDate = startDate
    }
    
    func editEndDate(endDate: Date) {
        taskEndDate = endDate
    }
    
    func revertTaskCompletion() {
        isTaskCompleted = false
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.title < rhs.title
    }
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title
    }
}
