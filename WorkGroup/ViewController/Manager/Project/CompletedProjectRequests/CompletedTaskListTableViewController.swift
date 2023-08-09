//
//  CompletedTaskListTableViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 07/08/2023.
//

import UIKit

class CompletedTaskListTableViewController: UITableViewController {

    @IBOutlet var taskListTableView: UITableView!
    var company: Company?
    private var taskCompleteRequestsMap: [Task: Project] = [:]
    var selectedProject: Project?
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        self.navigationItem.title = "COMPLETED TASK REQUESTS"
        taskListTableView.register(UINib(nibName: Constant.CustomCell.projectListCellNib, bundle: nil), forCellReuseIdentifier: Constant.CustomCell.projectListTableCellIdentifier)
       
    }
    
    private func loadData() {
        if let companySafe = company {
            if companySafe.projects.count > 0 {
                for project in companySafe.projects {
                    for completeRequestTask in project.completedTasksRequests {
                        taskCompleteRequestsMap[completeRequestTask] = project
                    }
                   
                }
            }
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return taskCompleteRequestsMap.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CustomCell.projectListTableCellIdentifier, for: indexPath) as! ProjectListTableCell
        let task = Array(taskCompleteRequestsMap.keys)[indexPath.row]
          
          let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell.progressBar.isHidden = true // Set your progress bar properties
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.description
        cell.startDateLabel.text = dateFormatter.string(from: task.taskStartDate)
        cell.endDateLabel.text = dateFormatter.string(from: task.taskEndDate)
          
          return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = Array(taskCompleteRequestsMap.keys)[indexPath.row]
        if let selectedTaskSafe = selectedTask {
            selectedProject = taskCompleteRequestsMap[selectedTaskSafe]
        }
        performSegue(withIdentifier: Constant.Segue.Manager.CompleteTaskRequest.taskRequestToTaskDetail, sender: self)
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.CompleteTaskRequest.taskRequestToTaskDetail {
            if let taskDetailsVC = segue.destination as? CompletionRequestTaskDetailsViewController {
                taskDetailsVC.project = selectedProject
                taskDetailsVC.task = selectedTask
                taskDetailsVC.company = company
            }
        }
    }


}
