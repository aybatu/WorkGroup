//
//  CreateProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 10/06/2023.
//

import UIKit

class CreateProjectViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var projectTasksButton: UIButton!
    @IBOutlet weak var projectTitleTextField: UITextField!
    @IBOutlet weak var projectDescriptionTextField: UITextField!
    
    @IBOutlet weak var createProjectNavBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        projectTitleTextField.delegate = self
        projectDescriptionTextField.delegate = self
        projectTasksButton.isEnabled = false
        createProjectNavBar.title = "Project Details"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    @IBAction func discard(_ sender: UIButton) {
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

extension CreateProjectViewController {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if projectTitleTextField.text?.isEmpty == false && projectDescriptionTextField.text?.isEmpty == false {
            projectTasksButton.isEnabled = true
        } else {
            projectTasksButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
