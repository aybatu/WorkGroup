//
//  EditTaskOfProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectEditTaskListViewController: UIViewController{
    var project: Project?
    private var selectedTask: Task?
    var company: Company?
    
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.register(UINib(nibName: Constant.CustomCell.projectListCellNib, bundle: nil), forCellReuseIdentifier: Constant.CustomCell.projectListTableCellIdentifier)
        navigationItem.title = "PROJECT'S TASKS LIST"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskListTableView.reloadData()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Project.EditProject.EditTask.taskListToEditTaskDetails {
            if let taskDetailsVC = segue.destination as? ProjectEditTaskDetailViewController {
                taskDetailsVC.task = selectedTask
                taskDetailsVC.project = project
                taskDetailsVC.company = company
            }
        }
    }

}

extension ProjectEditTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project?.tasks.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: Constant.CustomCell.projectListTableCellIdentifier, for: indexPath) as! ProjectListTableCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let project = project {
            let taskArray = project.tasks
            cell.titleLabel.text = taskArray[indexPath.row].title
            cell.descriptionLabel.text = taskArray[indexPath.row].description
            cell.startDateLabel.text = "Start date: \(dateFormatter.string(from: taskArray[indexPath.row].taskStartDate))"
            cell.endDateLabel.text = "End date: \(dateFormatter.string(from: taskArray[indexPath.row].taskEndDate))"
            cell.progressBar.progress = progressBarCaculator(startDate: taskArray[indexPath.row].taskStartDate, endDate: taskArray[indexPath.row].taskEndDate)
        }
        
        
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let project = project {
            let taskArr = Array(project.tasks)
            selectedTask = taskArr[indexPath.row]
            performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.EditTask.taskListToEditTaskDetails, sender: self)
        }
       
    }
 
}
