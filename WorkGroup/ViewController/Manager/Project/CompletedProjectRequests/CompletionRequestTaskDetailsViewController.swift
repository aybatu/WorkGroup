//
//  CompletionRequestTaskDetailsViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 07/08/2023.
//

import UIKit

class CompletionRequestTaskDetailsViewController: UIViewController {
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var assignedEmployeesLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var ProjectDescriptionLabel: UILabel!
    
    var company: Company?
    var project: Project?
    var task: Task?
    private lazy var taskService: TaskService = {
        return TaskService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let projectSafe = project {
            projectTitleLabel.text = projectSafe.title
            ProjectDescriptionLabel.text = projectSafe.description
            
        }
        var assignedEmployees: String = ""
        if let taskSafe = task {
            for employee in taskSafe.assignedEmployees {
                if taskSafe.assignedEmployees.last == employee {
                    assignedEmployees += "\(employee.userFirstName) \(employee.userLastName)"
                } else {
                    assignedEmployees += "\(employee.userFirstName) \(employee.userLastName), "
                }
                
            }
            assignedEmployeesLabel.text = assignedEmployees
            taskTitleLabel.text = taskSafe.title
            taskDescriptionLabel.text = taskSafe.description
        }
    }
    
    
    @IBAction func acceptRequestTap(_ sender: UIButton) {
        acceptRequest()
    }
    
    
    @IBAction func rejectRequestTap(_ sender: UIButton) {
        rejectRequest()
    }
    
    private func alert(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) {_ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func acceptRequest() {
        guard let companyRegNo = company?.registrationNumber, let project = project, let task = task else {return}
        
        let request = CompleteProjectTaskRequest(project: project, task: task)
        taskService.acceptTaskCompletionRequest(registrationNumber: companyRegNo, completeTaskRequest: request) { [weak self] isRequestAccepted, error in
            if isRequestAccepted {
                DispatchQueue.main.async {
                    self?.alert("Task is completed successfully.", "Successfull")
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.alert(error ?? "", "Error")
                }
            }
        }
    }
    
    private func rejectRequest() {
        guard let companyRegNo = company?.registrationNumber, let project = project, let task = task else {return}
        let request = CompleteProjectTaskRequest(project: project, task: task)
        
        taskService.rejectTaskCompletionRequest(registrationNumber: companyRegNo, rejectTaskRequest: request) {[weak self] isRejected, error in
            if isRejected {
                DispatchQueue.main.async {
                    self?.alert("The task completion request is rejected. Employee is assigned for the task again.", "Rejected")
                }
            } else {
                DispatchQueue.main.async {
                    self?.alert(error ?? "", "Error")
                }
            }
        }
    }
}
