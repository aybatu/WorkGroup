//
//  EmployeeAvailabilityValidator .swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 03/08/2023.
//

import Foundation

struct EmployeeAvailablityValidator {
    func checkEmployeeAvailablity(employee: Employee, completion: @escaping(AssignNewTaskToEmployee) -> Void) {
        if employee.userTasks.count < employee.employeeTaskCapacity {
            completion(.available)
        } else {
            completion(.unavailable(message: "Employee already assigned more than ten different tasks. To balance work load please choose another employee."))
        }
    }
}
