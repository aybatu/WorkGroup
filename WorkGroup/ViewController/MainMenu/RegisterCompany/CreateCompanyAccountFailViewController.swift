//
//  CreateCompanyAccountFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 17/06/2023.
//

import UIKit

class CreateCompanyAccountFailViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: UILabel!
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.text = errorMessage
        navigationItem.hidesBackButton = true
    }
    

    @IBAction func tryAgainButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBackToMainMenu(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
