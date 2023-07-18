//
//  EmployeeAssignedTaskListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeAssignedTaskListViewController: UIViewController {
   
    var employee: Employee?
    private var assignedTasks: [Task] = []
    private var selectedTask: Task?
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
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
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Employee.employeeTaskLisCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = assignedTasks[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = assignedTasks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Employee.AssignedTask.taskListToTaskDetails, sender: self)
    }
}
