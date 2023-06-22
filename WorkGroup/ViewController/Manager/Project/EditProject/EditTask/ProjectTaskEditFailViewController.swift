//
//  ProjectTaskEditFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectTaskEditFailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func tryAgainButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    @IBAction func backToMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}
