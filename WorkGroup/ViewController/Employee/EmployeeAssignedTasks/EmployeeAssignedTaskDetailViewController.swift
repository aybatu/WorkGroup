//
//  EmployeeAssignedTaskDetailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeAssignedTaskDetailViewController: UIViewController {
    @IBOutlet weak var projectTitleLabel: UILabel!
    
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    @IBOutlet weak var assignedEmployeesLabel: UILabel!
    var task: Task?
    var project: Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    
    
    private func loadData() {
        if let taskTitle = task?.title,
           let taskDescription = task?.description, let projectTitle = project?.title,
           let projectDescription = project?.description,
           let assignedEmployees = task?.assignedEmployees
        {
            taskTitleLabel.text = taskTitle
            taskDescriptionLabel.text = taskDescription
            projectDescriptionLabel.text = projectDescription
            projectTitleLabel.text = projectTitle
            
            var assignedEmployeesList = ""
            for employee in assignedEmployees {
                if assignedEmployees.last == employee {
                    assignedEmployeesList += "\(employee.userFirstName) \(employee.userLastName)"
                }else {
                    assignedEmployeesList += "\(employee.userFirstName) \(employee.userLastName), "
                }
                
            }
            assignedEmployeesLabel.text = assignedEmployeesList
        }
    }
    
}
