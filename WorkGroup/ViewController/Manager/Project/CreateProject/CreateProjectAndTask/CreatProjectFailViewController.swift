//
//  CreatProjectFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class CreatProjectFailViewController: UIViewController {
    
    @IBOutlet weak var createProjectErrorMessageTextField: UILabel!
    var errorMessage: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let error = errorMessage {
            createProjectErrorMessageTextField.text = error
        }
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func tryAgainButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        navController.popViewController(animated: true)
    }
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        
        navController.popToRootViewController(animated: true)
    }
    
    
}
