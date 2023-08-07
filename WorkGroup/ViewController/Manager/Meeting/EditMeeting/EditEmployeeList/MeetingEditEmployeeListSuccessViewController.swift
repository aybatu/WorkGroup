//
//  MeetingEditEmployeeListSuccessViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditEmployeeListSuccessViewController: UIViewController {

    @IBOutlet weak var responseLabel: UILabel!
    
    var response: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let responseSafe = response {
            responseLabel.text = responseSafe
        }
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}
