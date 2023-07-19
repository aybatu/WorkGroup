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
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskEndDatePicker: UIDatePicker!
    @IBOutlet weak var taskStartDatePicker: UIDatePicker!
    private var selectedButton: UIButton?
    private var tapGesture: UITapGestureRecognizer!
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeListDropDownMenuCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        return tableView
    }()
    
    private var employeeArray: [Employee?] = []
    private let textViewStyle = TextView()
    private let textFieldStyle = TextFieldStyle()
    private var assignedUserList: [Employee] = []
    private let dropDownMenu = EmployeeListDropDownMenu()
    private var taskSet: [Task] = []
    var company: Company?
    private  let loadingVC = LoadingViewController()
    var projectDetails: [String: Any?]?

    private var createProjectFailWithError: String = "There was an error while creating project. Please try again."
    private var addTaskFailWithError: String = "There was an error while adding the task. Please try again."
    private let taskEndDateLimiter = -1
    private let assignableTaskMinimumDayLimit = 1
  
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setUpDatePicker()
        loadUserAccount()
        setupTextArea() 
        tableView.register(EmployeeListDropDownMenuCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        navigationController?.title = "TASK DETAILS"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeFromSuperview()
        
    }
    private func setupTextArea() {
        textViewStyle.styleTextView(taskDescriptionTextView)
        textFieldStyle.styleTextField(taskTitleTextField)
        taskTitleTextField.delegate = self
    }
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
    }
    
    private func setUpDatePicker() {
        // Set the minimum and maximum dates for the startDatePicker
        if let projectStartDate = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectStartDate], let projectEndDate = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectEndDate] {
            let availableDayCountBeforeEndDate = Calendar.current.date(byAdding: .day, value: taskEndDateLimiter, to: projectEndDate as! Date)
            taskStartDatePicker.minimumDate = projectStartDate as? Date
            taskStartDatePicker.maximumDate = availableDayCountBeforeEndDate
            
            // Set the minimum and maximum dates for the endDatePicker
            taskEndDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: assignableTaskMinimumDayLimit, to: taskStartDatePicker.date)
            taskEndDatePicker.maximumDate = projectEndDate as? Date
        }
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
        
        if let projectEndDate = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectEndDate] {
            // Set the minimum and maximum dates for the endDatePicker
            taskEndDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: assignableTaskMinimumDayLimit, to: taskStartDatePicker.date)
            taskEndDatePicker.maximumDate = projectEndDate as? Date
        }
        
    }
    
    private func loadUserAccount() {
        if let companySafe = company {
            employeeArray = Array(companySafe.employeeAccounts)
            employeeArray.sort { (account1, account2) -> Bool in
                let name1 = "\(account1?.userFirstName ?? "") \(account1?.userLastName ?? "")"
                let name2 = "\(account2?.userFirstName ?? "") \(account2?.userLastName ?? "")"
                return name1 < name2
            }
        }
        employeeArray.insert(nil, at: 0)
     
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Dismiss the dropdown menu
        tableView.removeFromSuperview()
        
        // Dismiss the keyboard
        view.endEditing(true)
        
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
                    self?.resetTextFields()
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.CreateProject.CreateTask.addTaskToSuccess, sender: self)
                   
                case .failure(let error):
                    self?.addTaskFailWithError = error
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.CreateProject.CreateTask.addTaskToFail, sender: self)
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
        if segue.identifier == Constant.Segue.Manager.Project.CreateProject.CreateTask.addTaskToFail {
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
            dropDownMenu.showDropdownMenu(from: sender, with: Array(company.employeeAccounts), tableView: tableView) { userAccount in
                sender.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
            }
        }
    }
    
    private func addTask(completion: @escaping (AddTaskResult) -> Void) {
//        guard let taskName = taskTitleTextField.text, let taskDescription = taskDescriptionTextView.text else {
//            completion(.failure(message: "Task name and description must be filled. Please try again."))
//            return
//        }
//        let startDate = taskStartDatePicker.date
//        let endDate = taskEndDatePicker.date
//        if taskName == "" || taskDescription == "" {
//            completion(.failure(message: "Task name and description must be filled. Please try again."))
//            return
//        }
//        
//        if assignedUserList.isEmpty {
//            completion(.failure(message: "At least one employee must be assigned to the task. Please assign an employee and try again."))
//            return
//        }
//        
//        let newTask = Task(title: taskName, description: taskDescription, assignedEmployees: assignedUserList, taskStartDate: startDate, taskEndDate: endDate)
//        
//        let (inserted, _) = taskSet.insert(newTask)
//        
//        if !inserted {
//            completion(.failure(message: "A task with the same name already exists in the project. Please choose a different task name."))
//            return
//        } else {
//            for user in assignedUserList {
//                user.assignTask(task: newTask)
//            }
//        }
//        
//        completion(.success)
//        resetButtonTitles()
    }
    
    private func createProject(completion: @escaping (CreateProjectResult) -> Void) {
        guard let projectTitle = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectTitle] as? String,
              let projectDescription = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectDescription] as? String,
              let projectStartDate = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectStartDate] as? Date,
              let projectEndDate = projectDetails?[Constant.Dictionary.ProjectDetailsDictionary.projectEndDate] as? Date else {
            completion(.failure(message: "Some of the project fields are empty. Please check and try again."))
            return
        }
        
        if taskSet.isEmpty {
            completion(.failure(message: "At least one task must be created for the project. Please add a task and try again."))
            
        } else {
            
            let newProject = Project(title: projectTitle, description: projectDescription, tasks: taskSet, startDate: projectStartDate, finishDate: projectEndDate)
            
            if let company = company {
                company.addProject(newProject) { isProjectAdded in
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
        firstEmployeeButton.setTitle("Assign an Employee", for: .normal)
        secondEmployeeButton.setTitle("Assign an Employee", for: .normal)
        thirdEmployeeButton.setTitle("Assign an Employee", for: .normal)
        fourthEmployeeButton.setTitle("Assign an Employee", for: .normal)
        fifthEmployeeButton.setTitle("Assign an Employee", for: .normal)
    }
    
    private func resetTextFields() {
        taskTitleTextField.text = ""
        taskDescriptionTextView.text = ""
    }
}

extension ProjectAddTaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier, for: indexPath) as? EmployeeListDropDownMenuCell ?? EmployeeListDropDownMenuCell(style: .default, reuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        
        if let userAccount = employeeArray[indexPath.row] {
            cell.textLabel?.text = "\(userAccount.userFirstName) \(userAccount.userLastName)"
        } else {
            cell.textLabel?.text = "Assign an Employee"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let userAccount = employeeArray[indexPath.row] else {
//            
//            if selectedButton?.currentTitle != "Assign an Employee" {
//                let employeeName = selectedButton?.currentTitle
//                let _ = assignedUserList.contains { employee in
//                    if "\(employee.userFirstName) \(employee.userLastName)" == employeeName { assignedUserList.remove(employee)
//                        return true
//                    }
//                    return false
//                }
//            }
//                selectedButton?.setTitle("Assign an Employee", for: .normal)
// 
//            tableView.removeFromSuperview()
//            tableView.deselectRow(at: indexPath, animated: true)
//            return
//        }
//        
//        let (inserted, _) = assignedUserList.insert(userAccount)
//        
//        if !inserted {
//          
//            userExistAlert()
//        } else if selectedButton?.currentTitle != "Assign an Employee" {
//            let employeeName = selectedButton?.currentTitle
//            let shouldRemoveEmployee = assignedUserList.contains { employee in
//                if "\(employee.userFirstName) \(employee.userLastName)" == employeeName { assignedUserList.remove(employee)
//                    return true
//                }
//                return false
//            }
//            
//            if shouldRemoveEmployee {
//                userAccount.checkEmployeeAvailablity { [weak self] isAvailable in
//                    switch isAvailable {
//                    case .available:
//                        self?.selectedButton?.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
//                    case .unavailable(let error):
//                        self?.employeeIsNotAvailableAlert(message: error)
//                    }
//                }
//            }
//      
//        } else {
//            userAccount.checkEmployeeAvailablity { [weak self] isAvailable in
//                switch isAvailable {
//                case .available:
//                    self?.selectedButton?.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
//                case .unavailable(let error):
//                    self?.employeeIsNotAvailableAlert(message: error)
//                }
//            }
//      
//        }
//        
//           
//            
        
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

extension ProjectAddTaskDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.removeFromSuperview()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
