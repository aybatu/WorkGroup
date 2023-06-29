//
//  ProjectAddTaskViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class ProjectAddTaskDetailViewController: UIViewController {
    @IBOutlet weak var firstEmployeeButton: UIButton!
    @IBOutlet weak var secondEmployeeButton: UIButton!
    @IBOutlet weak var thirdEmployeeButton: UIButton!
    @IBOutlet weak var fourthEmployeeButton: UIButton!
    @IBOutlet weak var fifthEmployeeButton: UIButton!
    
    var projectDetails: [String: Any?]?
    var company: RegisteredCompany?
    private var assignedUserList: Set<UserAccount> = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeListDropDownMenuCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        return tableView
    }()
    private let dropDownMenu = EmployeeListDropDownMenu()
    private var taskSet: Set<Task> = []
    private var createProjectFailWithError: String = "There was an error while creating project. Please try again."
    private var addTaskFailWithError: String = "There was an error while adding the task. Please try again."
    private  let loadingVC = LoadingViewController()
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    private var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.register(EmployeeListDropDownMenuCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        navigationController?.title = "Task Details"
    }
    
    
    @IBAction func selectEmployeeTapped(_ sender: UIButton) {
        showDropDownMenu(sender: sender)
        selectedButton = sender
    }
    
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        loadingVC.modalPresentationStyle = .fullScreen
        
        loadingVC.dismiss(animated: false) { [weak self] in
            self?.addTask {[weak self] result in
                switch result {
                case .success:
                    self?.assignedUserList.removeAll()
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.Task.addTaskToSuccess, sender: self)
                case .failure(let error):
                    self?.addTaskFailWithError = error
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.Task.addTaskToFail, sender: self)
                }
            }
        }
    }
    
    @IBAction func createProjectButton(_ sender: UIButton) {
        
        loadingVC.modalPresentationStyle = .fullScreen
        
        present(loadingVC, animated: false)
        
        loadingVC.dismiss(animated: false) { [weak self] in
            self?.createProject {[weak self] result in
                switch result {
                case .success:
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.CreateProject.createProjectToSuccess, sender: self)
                case .failure(let error):
                    self?.createProjectFailWithError = error
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.CreateProject.createProjectToFail, sender: self)
                    
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Project.Task.addTaskToFail {
            if let addTaskFailVC = segue.destination as? ProjectAddTaskFailViewController {
                addTaskFailVC.errorMessage = addTaskFailWithError
            }
        }
        if segue.identifier == Constant.Segue.Manager.Project.CreateProject.createProjectToFail {
            if let createProjectFailVC = segue.destination as? CreatProjectFailViewController {
                createProjectFailVC.errorMessage = createProjectFailWithError
            }
        }
    }
    
    private func showDropDownMenu(sender: UIButton) {
        if let company = company {
            dropDownMenu.showDropdownMenu(from: sender, with: company.userAccounts, tableView: tableView) { userAccount in
                sender.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
            }
        }
    }
    
    private func addTask(completion: @escaping (AddTaskResult) -> Void) {
        guard let taskName = taskNameTextField.text, let taskDescription = taskDescriptionTextField.text else {
            completion(.failure(message: "Task name and description must be filled. Please try again."))
            return
        }
        
        if taskName == "" || taskDescription == "" {
            completion(.failure(message: "Task name and description must be filled. Please try again."))
            return
        }
        
        if assignedUserList.isEmpty {
            completion(.failure(message: "At least one employee must be assigned to the task. Please assign an employee and try again."))
            return
        }
        
        let newTask = Task(name: taskName, description: taskDescription, assignedEmployees: assignedUserList)
        let (inserted, _) = taskSet.insert(newTask)
        
        if !inserted {
            completion(.failure(message: "A task with the same name already exists in the project. Please choose a different task name."))
            return
        } else {
            for user in assignedUserList {
                user.assignTask(task: newTask)
            }
        }
        
        completion(.success)
        resetButtonTitles()
    }
    
    private func createProject(completion: @escaping (CreateProjectResult) -> Void) {
        guard let projectName = projectDetails?["ProjectTitle"] as? String,
              let projectDescription = projectDetails?["ProjectDescription"] as? String,
              let projectStartDate = projectDetails?["StartDate"] as? Date,
              let projectEndDate = projectDetails?["EndDate"] as? Date else {
            completion(.failure(message: "Some of the project fields are empty. Please check and try again."))
            return
        }
        
        if taskSet.isEmpty {
            completion(.failure(message: "At least one task must be created for the project. Please add a task and try again."))
            
        } else {
            
            let newProject = Project(name: projectName, description: projectDescription, tasks: taskSet, startDate: projectStartDate, finishDate: projectEndDate)
            
            if let company = company {
                company.addProject(project: newProject) { isProjectAdded in
                    if isProjectAdded {
                        completion(.success)
                    } else {
                        completion(.failure(message: "A project with the same name already exists. Please choose a different project name."))
                    }
                }
            }
        }
    }
    
    private func resetButtonTitles() {
           firstEmployeeButton.setTitle("Select Employee", for: .normal)
           secondEmployeeButton.setTitle("Select Employee", for: .normal)
           thirdEmployeeButton.setTitle("Select Employee", for: .normal)
           fourthEmployeeButton.setTitle("Select Employee", for: .normal)
           fifthEmployeeButton.setTitle("Select Employee", for: .normal)
       }
}

extension ProjectAddTaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return company?.userAccounts.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier, for: indexPath) as? EmployeeListDropDownMenuCell ?? EmployeeListDropDownMenuCell(style: .default, reuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        
        if let userAccount = company?.userAccounts[indexPath.row] {
            cell.textLabel?.text = "\(userAccount.userFirstName) \(userAccount.userLastName)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userAccount = company?.userAccounts[indexPath.row] else {
            return
        }
        
        let (inserted, _) = assignedUserList.insert(userAccount)
        
        if !inserted {
            userExistAlert()
        } else {
            userAccount.checkEmployeeAvailablity { [weak self] isAvailable in
                switch isAvailable {
                case .available:
                    self?.selectedButton?.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
                case .unavailable(let error):
                    self?.employeeIsNotAvailableAlert(message: error)
                }
            }
            
        }
        tableView.removeFromSuperview()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    private func userExistAlert() {
        let alertController = UIAlertController(title: "User Exists", message: "The employee is already assigned to the task. Please choose another employee.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    private func employeeIsNotAvailableAlert(message: String) {
        let alertController = UIAlertController(title: "Fail", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
