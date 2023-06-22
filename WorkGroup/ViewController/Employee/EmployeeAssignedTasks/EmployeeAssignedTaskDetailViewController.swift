//
//  EmployeeAssignedTaskDetailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeAssignedTaskDetailViewController: UIViewController {
    private var isTaskCompleted: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func markTaskCompleted(_ sender: UIButton) {
        if isTaskCompleted {
            performSegue(withIdentifier: Constant.Segue.Employee.taskDetailToSuccess, sender: nil)
        } else {
            performSegue(withIdentifier: Constant.Segue.Employee.taskDetailToFail, sender: nil)
        }
    }
    
    

}
