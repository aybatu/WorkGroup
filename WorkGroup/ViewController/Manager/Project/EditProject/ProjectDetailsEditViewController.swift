//
//  ProjectDetailsForEditViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectDetailsEditViewController: UIViewController {
    @IBOutlet weak var projectTitleTextField: UITextField!
    
    @IBOutlet weak var projectDescriptionTextView: UITextView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var project: Project?
    var company: Company?
    private let loadingVC = LoadingViewController()
    private let textViewStyle = TextView()
    private let textFieldStyle = TextFieldStyle()
    private var projectDetails: [String: Any?] = [
        Constant.Dictionary.ProjectDetailsDictionary.projectTitle: nil,
        Constant.Dictionary.ProjectDetailsDictionary.projectDescription: nil,
        Constant.Dictionary.ProjectDetailsDictionary.projectStartDate: Date(),
        Constant.Dictionary.ProjectDetailsDictionary.projectEndDate: Date()
    ]
    private var editProjectDetailFailWithError: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProjectData()
        setupTextArea()
        navigationItem.title = "PROJECT DETAILS"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextArea() {
        textViewStyle.styleTextView(projectDescriptionTextView)
        textFieldStyle.styleTextField(projectTitleTextField)
    }
    
    private func updateProjectData() {
        if let projectSafe = project {
            let projectTitle = projectSafe.title
            let projectDescription = projectSafe.description
            let projectStartDate = projectSafe.startDate
            let projectEndDate = projectSafe.endDate
            
            setUpDatePicker(projectStartDate: projectStartDate)
            
            projectTitleTextField.text = projectTitle
            projectDescriptionTextView.text = projectDescription
            startDatePicker.date = projectStartDate
            endDatePicker.date = projectEndDate
            
            
            projectDetails[Constant.Dictionary.ProjectDetailsDictionary.projectTitle] = projectTitle
            projectDetails[Constant.Dictionary.ProjectDetailsDictionary.projectDescription] = projectDescription
            projectDetails[Constant.Dictionary.ProjectDetailsDictionary.projectStartDate] = projectStartDate
            projectDetails[Constant.Dictionary.ProjectDetailsDictionary.projectEndDate] = projectEndDate
            
        }
    }
    
    private func setUpDatePicker(projectStartDate: Date) {
        // Set the minimum and maximum dates for the startDatePicker
        
        startDatePicker.minimumDate = projectStartDate
        startDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: projectStartDate)
        
        endDatePicker.center = .zero
        // Set the minimum and maximum dates for the endDatePicker
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 5, to: startDatePicker.date)
        endDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: startDatePicker.date)
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
        
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 5, to: sender.date)
        endDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: sender.date)
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        
        loadingVC.modalPresentationStyle = .fullScreen
        
        present(loadingVC, animated: false)
        
        
        editProjectDetails {[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.loadingVC.dismiss(animated: false) { [weak self] in
                        self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.projectDetailSaveToSuccess, sender: self)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.loadingVC.dismiss(animated: false) { [weak self] in
                        self?.editProjectDetailFailWithError = error
                        self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.projectDetailSaveToFail, sender: self)
                    }
                }
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Project.EditProject.editProjectDetailToTaskList {
            if let taskListVC = segue.destination as? ProjectEditTaskListViewController {
                if let project = project{
                    taskListVC.project = project
                    taskListVC.company = company
                }
            }
        }
        
        if segue.identifier == Constant.Segue.Manager.Project.EditProject.projectDetailSaveToFail {
            if let editFailVC = segue.destination as? ProjectDetailsChangeFailViewController {
                editFailVC.errorMsg = editProjectDetailFailWithError
            }
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

extension ProjectDetailsEditViewController {
    private func editProjectDetails(completion: @escaping (EditProjectResult) -> Void) {
        guard let projectTitle = projectTitleTextField.text,
              let projectDescription = projectDescriptionTextView.text,
              let originalProjectTitle = projectDetails[Constant.Dictionary.ProjectDetailsDictionary.projectTitle] as? String,
              let registrationNo = company?.registrationNumber
        else {
            completion(.failure(message: "Some of the project fields are empty. Please check and try again."))
            return
        }
        let projectService = ProjectService()
        
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        if projectTitle != originalProjectTitle {
            let isProjectTitleExist = company?.projects.contains { project in
                return project.title == projectTitle
            }
            
            if isProjectTitleExist ?? false {
                completion(.failure(message: "Project title exists. Please change the title and try again."))
            } else {
                if let projectSafe = project {
                    projectSafe.editTitle(newTitle: projectTitle)
                    projectSafe.editDecription(newDescription: projectDescription)
                    projectSafe.editStartDate(newStartDate: startDate)
                    projectSafe.editEndDate(newEndDate: endDate)
                    
                    let newUpdateRequest = UpdateProjectRequest(originalProjectTitle: originalProjectTitle, updatedProject: projectSafe)
                    projectService.updateProject(registrationNumber: registrationNo, updatedProjectRequest: newUpdateRequest) { isProjectUpdated, errorMsg in
                        if isProjectUpdated {
                            completion(.success)
                        } else {
                            completion(.failure(message: errorMsg ?? ""))
                        }
                    }
                }
            }
        } else {
            if let projectSafe = project {
                projectSafe.editTitle(newTitle: projectTitle)
                projectSafe.editDecription(newDescription: projectDescription)
                projectSafe.editStartDate(newStartDate: startDate)
                projectSafe.editEndDate(newEndDate: endDate)
                
                let newUpdateRequest = UpdateProjectRequest(originalProjectTitle: originalProjectTitle, updatedProject: projectSafe)
                projectService.updateProject(registrationNumber: registrationNo, updatedProjectRequest: newUpdateRequest) { isProjectUpdated, errorMsg in
                    if isProjectUpdated {
                        completion(.success)
                    } else {
                        completion(.failure(message: errorMsg ?? ""))
                    }
                }
                
            }
        }
        
    }
    
    
}
