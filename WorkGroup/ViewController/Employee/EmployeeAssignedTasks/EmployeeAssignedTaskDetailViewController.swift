//
//  EmployeeAssignedTaskDetailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeAssignedTaskDetailViewController: UIViewController {
    @IBOutlet weak var taskTitleTextLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionTextLabel: UILabel!
    
    @IBOutlet weak var taskEndDateTextLabel: UILabel!
    @IBOutlet weak var taskStartDateTextLabel: UILabel!
    private var isTaskCompleted: Bool = true
    var task: Task?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    @IBAction func markTaskCompleted(_ sender: UIButton) {
        if isTaskCompleted {
            performSegue(withIdentifier: Constant.Segue.Employee.AssignedTask.taskDetailToSuccess, sender: nil)
        } else {
            performSegue(withIdentifier: Constant.Segue.Employee.AssignedTask.taskDetailToFail, sender: nil)
        }
    }
    
    private func loadData() {
        if let taskTitle = task?.title,
            let taskDescription = task?.description,
            let taskStartDate = task?.taskStartDate,
            let taskEndDate = task?.taskEndDate {
            taskTitleTextLabel.text = taskTitle
            taskDescriptionTextLabel.text = taskDescription
            taskStartDateTextLabel.text = dateFormatter.string(from: taskStartDate)
            taskEndDateTextLabel.text = dateFormatter.string(from: taskEndDate)
            
            
        }
    }

}
