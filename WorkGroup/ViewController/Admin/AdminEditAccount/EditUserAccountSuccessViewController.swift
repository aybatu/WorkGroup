//
//  EditUserAccountSuccessViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    

    @IBAction func accountListButton(_ sender: UIButton) {
        guard let navController = self.navigationController else {return}
        let viewControllers = navController.viewControllers
        if viewControllers.count > 0 {
            let accountListViewController = viewControllers[1]
            navController.popToViewController(accountListViewController, animated: true)
            
        }
    }
    
    @IBAction func backToMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
