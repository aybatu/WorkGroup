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
    
    @IBOutlet weak var projectDescriptionTextView: UITextView!
    
    @IBOutlet weak var createProjectNavBar: UINavigationItem!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    var company: Company?
    private let textViewStyle = TextView()
    private let textFieldStyle = TextFieldStyle()
    private var projectDetails: [String: Any?] = [
        Constant.Dictionary.ProjectDetailsDictionary.projectTitle: nil,
        Constant.Dictionary.ProjectDetailsDictionary.projectDescription: nil,
        Constant.Dictionary.ProjectDetailsDictionary.projectStartDate: Date(),
        Constant.Dictionary.ProjectDetailsDictionary.projectEndDate: Date()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProjectNavBar.title = "PROJECT DETAILS"
        projectTasksButton.isEnabled = false
        setUpDatePicker()
        setupTextArea()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    private func setupTextArea() {
        projectTitleTextField.delegate = self
        projectDescriptionTextView.delegate = self
        textViewStyle.styleTextView(projectDescriptionTextView)
        textFieldStyle.styleTextField(projectTitleTextField)
    }
    
    private func setUpDatePicker() {
        
        // Set the minimum and maximum dates for the startDatePicker
        startDatePicker.minimumDate = Date()
        startDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        
        // Set the minimum and maximum dates for the endDatePicker
        updateEndDatePickerLimits()
    }
    
    private func updateEndDatePickerLimits() {
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 5, to: startDatePicker.date)
        endDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: startDatePicker.date)
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
        
        updateEndDatePickerLimits()
    }
    
    @IBAction func discard(_ sender: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("Discard", comment: ""),
                                                message: NSLocalizedString("Are you sure you want to discard?", comment: ""),
                                                preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: NSLocalizedString("Discard", comment: ""),
                                          style: .destructive) { [weak self] (_) in
            self?.performDiscard()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel)
        
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    private func performDiscard() {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let projectTitle = projectTitleTextField.text, let projectDescription = projectDescriptionTextView.text {
            
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            projectDetails.updateValue(projectTitle, forKey: Constant.Dictionary.ProjectDetailsDictionary.projectTitle)
            projectDetails.updateValue(projectDescription, forKey: Constant.Dictionary.ProjectDetailsDictionary.projectDescription)
            projectDetails.updateValue(startDate, forKey: Constant.Dictionary.ProjectDetailsDictionary.projectStartDate)
            projectDetails.updateValue(endDate, forKey: Constant.Dictionary.ProjectDetailsDictionary.projectEndDate)
            
            
            if segue.identifier == Constant.Segue.Manager.Project.CreateProject.projectDetailsToTaskView {
                if let addTaskVC = segue.destination as? ProjectAddTaskDetailViewController {
                    addTaskVC.projectDetails = projectDetails
                    addTaskVC.company = company
                }
            }
        }
    }
    
    func enableProjectTaskButton(isTitle: Bool, isDescription: Bool) {
        projectTasksButton.isEnabled = isTitle && isDescription
    }
    
}

extension ProjectDetailsViewController: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        var isTitle = projectTitleTextField.text != ""
        let isDescription = projectDescriptionTextView.text != ""
        
        switch textField {
        case projectTitleTextField:
            isTitle = updatedText != ""
            enableProjectTaskButton(isTitle: isTitle, isDescription: isDescription)
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateProjectTaskButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateProjectTaskButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func updateProjectTaskButtonState() {
        let isTitle = projectTitleTextField.text?.isEmpty == false
        let isDescription = projectDescriptionTextView.text?.isEmpty == false
        enableProjectTaskButton(isTitle: isTitle, isDescription: isDescription)
    }
}

