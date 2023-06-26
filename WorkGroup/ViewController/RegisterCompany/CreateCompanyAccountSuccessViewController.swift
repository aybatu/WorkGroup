//
//  CreateCompanyAccountSuccessViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 17/06/2023.
//

import UIKit

class CreateCompanyAccountSuccessViewController: UIViewController {
    var registrationNo: String?
    @IBOutlet weak var registrationNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationNumberLabel.text = registrationNo
        navigationItem.hidesBackButton = true
    }
    

    @IBAction func goBackToMainMenu(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
      
    }
    
}
