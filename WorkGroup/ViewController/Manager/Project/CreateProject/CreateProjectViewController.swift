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
        createProjectNavBar.title = "Project Information"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

       
    }
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
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true)
    }
    

}
