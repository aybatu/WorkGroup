//
//  CreateProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 10/06/2023.
//

import UIKit

class ProjectDetailsViewController: UIViewController {
    @IBOutlet weak var projectTasksButton: UIButton!
    @IBOutlet weak var projectTitleTextField: UITextField!
    @IBOutlet weak var projectDescriptionTextField: UITextField!
    
    @IBOutlet weak var createProjectNavBar: UINavigationItem!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    var company: RegisteredCompany?
    private var projectDetails: [String: Any?] = [
        "ProjectTitle": nil,
        "ProjectDescription": nil,
        "StartDate": Date(),
        "EndDate": Date()
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        projectTitleTextField.delegate = self
        projectDescriptionTextField.delegate = self
        projectTasksButton.isEnabled = false
        createProjectNavBar.title = "Project Details"
        setUpDatePicker()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    private func setUpDatePicker() {
        // Set the minimum and maximum dates for the startDatePicker
            startDatePicker.minimumDate = Date()
            startDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
            
            // Set the minimum and maximum dates for the endDatePicker
            endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 5, to: startDatePicker.date)
            endDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 35, to: startDatePicker.date)
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
       
            endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 5, to: sender.date)
            endDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 35, to: sender.date)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let projectTitle = projectTitleTextField.text, let projectDescription = projectDescriptionTextField.text {
            
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            projectDetails.updateValue(projectTitle, forKey: "ProjectTitle")
            projectDetails.updateValue(projectDescription, forKey: "ProjectDescription")
            projectDetails.updateValue(startDate, forKey: "StartDate")
            projectDetails.updateValue(endDate, forKey: "EndDate")
            
            
            if segue.identifier == Constant.Segue.Manager.Project.projectDetailsToTaskView {
                if let addTaskVC = segue.destination as? ProjectAddTaskDetailViewController {
                    addTaskVC.projectDetails = projectDetails
                    addTaskVC.company = company
                }
            }
        }
    }
    
    func enableProjectTaskButton(isTitle: Bool, isDescription: Bool) {
        if isTitle && isDescription {
            projectTasksButton.isEnabled = true
        } else {
            projectTasksButton.isEnabled = false
        }
    }
    
}

extension ProjectDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedText =  (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {return true}
        var isTitle = projectTitleTextField.text != ""
        var isDescription = projectDescriptionTextField.text != ""
        
        switch textField {
        case projectTitleTextField:
            isTitle = updatedText != ""
         
            enableProjectTaskButton(isTitle: isTitle, isDescription: isDescription)
        case projectDescriptionTextField:
            
                isDescription = updatedText != ""
            
            enableProjectTaskButton(isTitle: isTitle, isDescription: isDescription)
        default:
            break
        }
        
       
        
        return true
                
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
    
}

