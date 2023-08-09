//
//  EmployeeAssignedTaskListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeAssignedTaskListViewController: UIViewController {
   
    var employee: Employee?
    var company: Company?
    private var assignedTasks: [Task] = []
    private var selectedTask: Task?
    private var selectedProject: Project?
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.register(UINib(nibName: Constant.CustomCell.projectListCellNib, bundle: nil), forCellReuseIdentifier: Constant.CustomCell.projectListTableCellIdentifier)
    }
    

    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func loadData() {
        if let employeeSafe = employee {
            assignedTasks = Array(employeeSafe.userTasks)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Employee.AssignedTask.taskListToTaskDetails {
            if let taskDetailVC = segue.destination as? EmployeeAssignedTaskDetailViewController {
                if let selectedTaskSafe = selectedTask {
                    taskDetailVC.task  = selectedTaskSafe
                    taskDetailVC.project = selectedProject
                }
            }
        }
        
    }
 
}

extension EmployeeAssignedTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: Constant.CustomCell.projectListTableCellIdentifier, for: indexPath) as! ProjectListTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        cell.titleLabel.text = assignedTasks[indexPath.row].title
        cell.descriptionLabel.text = assignedTasks[indexPath.row].description
        cell.endDateLabel.text = dateFormatter.string(from: assignedTasks[indexPath.row].taskEndDate)
        cell.startDateLabel.text = dateFormatter.string(from: assignedTasks[indexPath.row].taskStartDate)
        cell.progressBar.progress = progressBarCaculator(startDate: assignedTasks[indexPath.row].taskStartDate, endDate: assignedTasks[indexPath.row].taskEndDate)
     
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { [weak self] (_, _, completionHandler) in
               let selectedTask = self?.assignedTasks[indexPath.row]
            if let selectedTaskSafe = selectedTask {
                self?.sendTaskCompletionRequest(selectedTaskSafe)
                self?.assignedTasks.remove(at: indexPath.row)
                tableView.reloadData()
                completionHandler(true)
            } else {
                completionHandler(false)
            }
             
           }
           
           // Customize the button style to indicate interaction
           completeAction.backgroundColor = UIColor.systemGreen
           completeAction.image = UIImage(systemName: "checkmark.circle.fill")
           completeAction.title = "Complete"
           
           let configuration = UISwipeActionsConfiguration(actions: [completeAction])
        
           return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = assignedTasks[indexPath.row]
        guard let selectedTask = selectedTask, let employee = employee, let company = company else {return}
        selectedProject = company.projects.first(where: { $0.tasks.contains(selectedTask) && $0.tasks.contains(where: { $0.assignedEmployees.contains(employee) }) })
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Employee.AssignedTask.taskListToTaskDetails, sender: self)
    }
    
    private func progressBarCaculator(startDate: Date, endDate: Date) -> Float {
        let currentDate = Date()
           
           // Calculate the time interval between endDate and startDate
           let totalTime = endDate.timeIntervalSince(startDate)
           
           // Calculate the time interval between currentDate and startDate
           let passedTime = currentDate.timeIntervalSince(startDate)
           
           // Ensure passedTime does not exceed totalTime (clamp it between 0 and totalTime)
           let clampedPassedTime = max(0, min(passedTime, totalTime))
           
           // Calculate the progress as a percentage
           let progress = Float(clampedPassedTime) / Float(totalTime)
           
           return progress
        
    }
    
    private func sendTaskCompletionRequest(_ task: Task) {
        guard let employee = employee else {return}
        guard let company = company,
               let companyRegNo = company.registrationNumber,
               let foundProject = company.projects.first(where: { $0.tasks.contains(task) && $0.tasks.contains(where: { $0.assignedEmployees.contains(employee) }) })
         else {
             return
         }
        
         let taskCompletionRequest = TaskCompletionRequest(project: foundProject, task: task)
         let taskService = TaskService()
        
        taskService.sendCompleteTaskRequest(registrationNumber: companyRegNo, taskCompleteRequest: taskCompletionRequest) { [weak self, weak foundProject, weak task] isRequestSent, error in
            guard let self = self, let foundProject = foundProject, let task = task else {
                return
            }
            
            if isRequestSent {
                if let taskIndex = foundProject.tasks.firstIndex(of: task) {
                    foundProject.tasks.remove(at: taskIndex)
                    foundProject.completedTasksRequests.append(task)
                }
              
                DispatchQueue.main.async {
                    self.alert(title: "Successful", message: "Project completion request has been sent to the manager. Once it's approved, the task will be completed.")
                }
            } else {
                DispatchQueue.main.async {
                    self.alert(title: "Error", message: error ?? "")
                }
            }
        }
    }
    
    private func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}
