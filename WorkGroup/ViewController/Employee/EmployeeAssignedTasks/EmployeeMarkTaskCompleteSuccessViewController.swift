//
//  EmployeeMarkTaskCompleteSuccessViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeMarkTaskCompleteSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    
    @IBAction func backToTaskListButton(_ sender: UIButton) {
        guard let navContoller = self.navigationController else {return}
        let viewControllers = navContoller.viewControllers
        
        if viewControllers.count > 0 {
            let taskListViewController = viewControllers[1]
            navContoller.popToViewController(taskListViewController, animated: true)
        }
    }
    
   
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
