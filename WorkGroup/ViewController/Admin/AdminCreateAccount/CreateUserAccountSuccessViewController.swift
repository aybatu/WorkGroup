//
//  CreateAccountSuccessViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class CreateUserAccountSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func createNewUserAccButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBackToMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
