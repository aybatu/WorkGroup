//
//  EditUserAccountFailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountFailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func tryAgainButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
