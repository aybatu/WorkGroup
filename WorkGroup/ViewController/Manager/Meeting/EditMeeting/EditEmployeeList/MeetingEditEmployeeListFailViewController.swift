//
//  MeetingEditEmployeeListFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditEmployeeListFailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
