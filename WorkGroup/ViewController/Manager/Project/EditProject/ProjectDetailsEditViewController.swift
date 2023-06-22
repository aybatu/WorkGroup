//
//  ProjectDetailsForEditViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectDetailsEditViewController: UIViewController {
    let isChangesSaved = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Project Details"
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        if isChangesSaved {
            performSegue(withIdentifier: Constant.Segue.Manager.projectDetailSaveToSuccess, sender: self)
        } else {
            performSegue(withIdentifier: Constant.Segue.Manager.projectDetailSaveToFail, sender: self)
        }
    }
    
    @IBAction func discardButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard?", preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
            self.performDiscard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func performDiscard() {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    
}
