//
//  EditTaskOfProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectEditTaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let taskList: [String] = ["Task1", "Task2", "Task3"]
    
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        navigationItem.title = "Project's Task List"
    }

}

extension ProjectEditTaskListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.taskListCellIdentifier, for: indexPath)
        cell.textLabel?.text = taskList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Manager.taskListToEditTaskDetails, sender: self)
    }
}
