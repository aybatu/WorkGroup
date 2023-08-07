//
//  MeetingEditEmployeeListFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditEmployeeListFailViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    var errorMsg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let errorMsg = errorMsg {
            errorLabel.text = errorMsg
        }
        navigationItem.hidesBackButton = true
    }
    

    @IBAction func tryAgainButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}
