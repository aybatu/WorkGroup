//
//  ProjectAddTaskFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 20/06/2023.
//

import UIKit

class ProjectAddTaskFailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    
    @IBAction func tryAgainButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        navController.popViewController(animated: true)
    }
    
    @IBAction func backToMenuButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        navController.popToRootViewController(animated: true)
    }
    

}
