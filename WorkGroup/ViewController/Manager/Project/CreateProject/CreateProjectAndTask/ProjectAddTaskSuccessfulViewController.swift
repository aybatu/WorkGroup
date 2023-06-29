//
//  ProjectAddTaskSuccessfulViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 20/06/2023.
//

import UIKit

class ProjectAddTaskSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    

    @IBAction func backToTaskMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        
        navigationController.popViewController(animated: true)
    }
    

}
