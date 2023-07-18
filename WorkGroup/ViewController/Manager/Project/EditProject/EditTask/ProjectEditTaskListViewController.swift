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
        navigationItem.title = "PROJECT'S TASKS LIST"
    }

}

extension ProjectEditTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project?.tasks.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.taskListCellIdentifier, for: indexPath)
        if let project = project {
            let taskArray = Array(project.tasks)
            cell.textLabel?.text = taskArray[indexPath.row].title
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
