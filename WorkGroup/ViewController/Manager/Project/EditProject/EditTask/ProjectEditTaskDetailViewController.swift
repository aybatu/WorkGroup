//
//  ProjectEditTaskDetailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectEditTaskDetailViewController: UIViewController {
    let isTaskEdited = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        if isTaskEdited {
            performSegue(withIdentifier: Constant.Segue.Manager.editTaskToSuccess, sender: self)
        } else {
            performSegue(withIdentifier: Constant.Segue.Manager.editTaskToFail, sender: self)
        }
    }
    
    

}
