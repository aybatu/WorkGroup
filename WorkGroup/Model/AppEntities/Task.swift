//
//  Task.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import Foundation

class Task: Codable, Comparable, Hashable {
   
    var title: String
    var description: String
    var assignedEmployees: [Employee]
    var taskEmployeeLimit = 5
    var isTaskCompleted: Bool = false
    var taskStartDate: Date
    var taskEndDate: Date
    var taskCompleteRequest = false
    private let customDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    
    enum CodingKeys: String, CodingKey {
           case title
           case description
           case assignedEmployees
           case taskStartDate
           case taskEndDate
       }
    
    init(title: String, description: String, assignedEmployees: [Employee], taskStartDate: Date, taskEndDate: Date) {
        self.title = title
        self.description = description
        self.assignedEmployees = assignedEmployees
        self.taskStartDate = taskStartDate
        self.taskEndDate = taskEndDate
    }
    
    
    func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(title, forKey: .title)
         try container.encode(description, forKey: .description)
         try container.encode(assignedEmployees, forKey: .assignedEmployees)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        try container.encode(dateFormatter.string(from: taskStartDate), forKey: .taskStartDate)
        try container.encode(dateFormatter.string(from: taskEndDate), forKey: .taskEndDate)
     }

     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         title = try container.decode(String.self, forKey: .title)
         description = try container.decode(String.self, forKey: .description)
         assignedEmployees = try container.decode([Employee].self, forKey: .assignedEmployees)
         // Decode dates using the custom date format
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = customDateFormat
         
         if let taskStartDateString = try? container.decode(String.self, forKey: .taskStartDate),
            let taskStartDate = dateFormatter.date(from: taskStartDateString) {
             self.taskStartDate = taskStartDate
         } else {
             throw DecodingError.dataCorruptedError(forKey: .taskStartDate, in: container, debugDescription: "Invalid date format")
         }
         
         if let taskEndDateString = try? container.decode(String.self, forKey: .taskEndDate),
            let taskEndDate = dateFormatter.date(from: taskEndDateString) {
             self.taskEndDate = taskEndDate
         } else {
             throw DecodingError.dataCorruptedError(forKey: .taskEndDate, in: container, debugDescription: "Invalid date format")
         }
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.title < rhs.title
    }
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title
    }
}
