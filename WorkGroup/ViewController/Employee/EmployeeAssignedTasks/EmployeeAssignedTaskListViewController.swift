//
//  EmployeeAssignedTaskListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeAssignedTaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private let assignedTasks = ["Task1", "Task2", "Task3"]
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskListTableView.delegate = self
        taskListTableView.dataSource = self
    }
    

    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Employee.employeeTaskLisCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = assignedTasks[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Employee.taskListToTaskDetails, sender: self)
    }
}
