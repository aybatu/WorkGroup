//
//  EditEmployeeAccountDetailsViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountDetailsViewController: UIViewController {
    private var isAccountChanged = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func discardButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard?", preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
            self.performDiscard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    private func performDiscard() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        if isAccountChanged{
            performSegue(withIdentifier: Constant.Segue.Admin.editUserAccountToSuccess, sender: self)
        } else {
            performSegue(withIdentifier: Constant.Segue.Admin.editUserAccountToFail, sender: self)
         
        }
    }
    
}
