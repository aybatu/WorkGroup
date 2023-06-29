//
//  CreatProjectSuccessfulViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class CreatProjectSuccessfulViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func createNewProjectButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        let viewControllers = navController.viewControllers
        
        if viewControllers.count > 0 {
            let projectDetailsVC = viewControllers[1]
            navController.popToViewController(projectDetailsVC, animated: true)
        }
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        navController.popToRootViewController(animated: true)
    }
    
}
