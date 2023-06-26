//
//  EditUserAccountFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountFailViewController: UIViewController {

    @IBOutlet weak var editFailMessageLabel: UILabel!
    var failMessage: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let failMessage = failMessage {
            editFailMessageLabel.text = failMessage
        }
    }
    


    @IBAction func tryAgainButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
