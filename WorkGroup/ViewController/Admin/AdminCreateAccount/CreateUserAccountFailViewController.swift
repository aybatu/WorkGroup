//
//  CreateAccountFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class CreateUserAccountFailViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: UILabel!
    var errorMessage: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        if let errorMessage = errorMessage {
            errorMessageLabel.text = errorMessage
        }
    }
    

    @IBAction func tryAgainButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBackToMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
