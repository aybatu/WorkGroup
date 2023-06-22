//
//  ProjectAddTaskViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class ProjectAddTaskDetailViewController: UIViewController {
    let isTaskAdded = true
    let isProjectCreated = true
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {return}
        navigationController.title = "Task Details"
    }
    

    @IBAction func addTaskButton(_ sender: UIButton) {
        if isTaskAdded {
            performSegue(withIdentifier: Constant.Segue.Manager.addTaskToSuccess, sender: self)
        } else {
            performSegue(withIdentifier: Constant.Segue.Manager.addTaskToFail, sender: self)
        }
    }
    
    @IBAction func createProjectButton(_ sender: UIButton) {
        if isProjectCreated {
            performSegue(withIdentifier: Constant.Segue.Manager.createProjectToSuccess, sender: self)
        } else {
            performSegue(withIdentifier: Constant.Segue.Manager.createProjectToFail, sender: self
            )
        }
    }
}
