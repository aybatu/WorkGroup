//
//  CreateAccountFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class CreateUserAccountFailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    

    @IBAction func tryAgainButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBackToMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
