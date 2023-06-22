//
//  CreatProjectFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class CreatProjectFailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
