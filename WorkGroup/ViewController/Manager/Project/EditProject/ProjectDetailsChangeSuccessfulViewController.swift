//
//  ProjectTaskAddSuccessfulViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectDetailsChangeSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    

  
    @IBAction func projectListButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        let viewControllers = navigationController.viewControllers
        
        if viewControllers.count > 0 {
            let projectListViewController = navigationController.viewControllers[1]
            navigationController.popToViewController(projectListViewController, animated: true)
        }
    }
    
    @IBAction func backToMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}
