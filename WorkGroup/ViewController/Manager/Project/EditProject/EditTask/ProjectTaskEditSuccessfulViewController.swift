//
//  ProjectTaskEditSuccessfulViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectTaskEditSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    
    @IBAction func taskListButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        let viewControllers = navigationController.viewControllers
        if viewControllers.count > 0 {
            let taskListViewController = viewControllers[3]
            navigationController.popToViewController(taskListViewController, animated: true)
        }
    }
    
    @IBAction func backToMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    

}
