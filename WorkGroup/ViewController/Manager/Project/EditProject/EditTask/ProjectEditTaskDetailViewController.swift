//
//  ProjectEditTaskDetailViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectEditTaskDetailViewController: UIViewController {
    
    var task: Task?
    var project: Project?
    var company: RegisteredCompany?
    private let textViewStyle = TextView()
    private let textFieldStyle = TextFieldStyle()
    private var assignedEmployees: Set<UserAccount> = []
    private var employeeArr: [UserAccount?] = []
    private let dropDownMenu = EmployeeListDropDownMenu()
    private var errorWithFail: String?
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeListDropDownMenuCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        return tableView
    }()
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var firstEmployeeButton: UIButton!
    @IBOutlet weak var secondEmployeeButton: UIButton!
    @IBOutlet weak var thirdEmployeeButton: UIButton!
    @IBOutlet weak var fourthEmployeeButton: UIButton!
    @IBOutlet weak var fifthEmployeeButton: UIButton!
    @IBOutlet weak var taskEndDatePicker: UIDatePicker!
    @IBOutlet weak var taskStartDatePicker: UIDatePicker!
    
    private var tapGesture: UITapGestureRecognizer!
    private var selectedButton: UIButton?
    
    private var taskEndDateLimiter = -1
    private var assignableTaskMinimumDayLimit = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EmployeeListDropDownMenuCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        styleTextArea()
        setUpTextFields()
        setupTapGesture()
        setUpButtonTitle()
        loadData()
        setUpDatePickerDates()
        setUpDatePickerRanges()
        navigationController?.title = "EDIT TASK DETAILS"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeFromSuperview()
        
    }
    
    
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Dismiss the dropdown menu
        tableView.removeFromSuperview()
        
        // Dismiss the keyboard
        view.endEditing(true)
        
    }
    private func styleTextArea() {
        textViewStyle.styleTextView(taskDescriptionTextView)
        textFieldStyle.styleTextField(taskTitleTextField)
    }
    
    private func setUpTextFields() {
        if let task = task {
            taskTitleTextField.text = task.title
            taskDescriptionTextView.text = task.description
        }
    }
    private func loadData() {
        if let taskSafe = task, let companySafe = company {
            assignedEmployees = taskSafe.assignedEmployees
            employeeArr = Array(companySafe.userAccounts)
            employeeArr.insert(nil, at: 0)
        }
    }
    private func setUpButtonTitle() {
        if let task = task {
            let assignedEmployeesArr = Array(task.assignedEmployees)
            
            if assignedEmployeesArr.count >= 1 {
                firstEmployeeButton.setTitle("\(assignedEmployeesArr[0].userFirstName) \(assignedEmployeesArr[0].userLastName)", for: .normal)
            }
            if assignedEmployeesArr.count >= 2 {
                secondEmployeeButton.setTitle("\(assignedEmployeesArr[1].userFirstName) \(assignedEmployeesArr[1].userLastName)", for: .normal)
            }
            if assignedEmployeesArr.count >= 3 {
                thirdEmployeeButton.setTitle("\(assignedEmployeesArr[2].userFirstName) \(assignedEmployeesArr[2].userLastName)", for: .normal)
            }
            if assignedEmployeesArr.count >= 4 {
                fourthEmployeeButton.setTitle("\(assignedEmployeesArr[3].userFirstName) \(assignedEmployeesArr[3].userLastName)", for: .normal)
            }
            if assignedEmployeesArr.count >= 5 {
                fifthEmployeeButton.setTitle("\(assignedEmployeesArr[4].userFirstName) \(assignedEmployeesArr[4].userLastName)", for: .normal)
            }
        }
    }
    
    private func setUpDatePickerDates() {
        if let task = task {
            taskStartDatePicker.date = task.taskStartDate
            taskEndDatePicker.date = task.taskEndDate
        }
    }
    
    private func setUpDatePickerRanges() {
        // Set the minimum and maximum dates for the startDatePicker
        if let project = project {
            let availableDayCountBeforeEndDate = Calendar.current.date(byAdding: .day, value: taskEndDateLimiter, to: project.finishDate)
            taskStartDatePicker.minimumDate = project.startDate
            taskStartDatePicker.maximumDate = availableDayCountBeforeEndDate
            
            
            // Set the minimum and maximum dates for the endDatePicker
            taskEndDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: assignableTaskMinimumDayLimit, to: taskStartDatePicker.date)
            taskEndDatePicker.maximumDate = project.finishDate
        }
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
        if let project = project {
            let projectEndDate = project.finishDate
            // Set the minimum and maximum dates for the endDatePicker
            taskEndDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: assignableTaskMinimumDayLimit, to: taskStartDatePicker.date)
            taskEndDatePicker.maximumDate = projectEndDate
        }
    }
    
    @IBAction func selectEmployeeButton(_ sender: UIButton) {
        showDropDownMenu(sender: sender)
        selectedButton = sender
    }
    @IBAction func saveChangesButton(_ sender: UIButton) {
        editTask { [weak self] isTask in
            switch isTask {
            case .success:
                if let taskSafe = self?.task, let newAssignedEmployeesSafe = self?.assignedEmployees {
                    let oldAssignedEmployees = taskSafe.assignedEmployees
                    for employee in oldAssignedEmployees {
                        employee.removeTask(task: taskSafe)
                    }
                    for employee in newAssignedEmployeesSafe {
                        employee.assignTask(task: taskSafe)
                    }
                    self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.EditTask.editTaskToSuccess, sender: self)
                }
                
                
            case .failure(let message):
                self?.errorWithFail = message
                self?.performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.EditTask.editTaskToFail, sender: self)
            }
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Project.EditProject.EditTask.editTaskToFail {
            if let editFailVC = segue.destination as? ProjectTaskEditFailViewController {
                editFailVC.errorMsg = errorWithFail
            }
        }
    }
    
    private func showDropDownMenu(sender: UIButton) {
        if let company = company {
            let userAccountArray = Array(company.userAccounts)
            dropDownMenu.showDropdownMenu(from: sender, with: userAccountArray, tableView: tableView) { userAccount in
                sender.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
            }
        }
    }
    
}

extension ProjectEditTaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier, for: indexPath) as? EmployeeListDropDownMenuCell ?? EmployeeListDropDownMenuCell(style: .default, reuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.employeeListDropDownMenuForTaskCellIdentifier)
        
        if let userAccount = employeeArr[indexPath.row] {
            cell.textLabel?.text = "\(userAccount.userFirstName) \(userAccount.userLastName)"
        } else {
            cell.textLabel?.text = "Assign an Employee"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userAccount = employeeArr[indexPath.row] else {
            
            if selectedButton?.currentTitle != "Assign an Employee" {
                let employeeName = selectedButton?.currentTitle
                let _ = assignedEmployees.contains { employee in
                    if "\(employee.userFirstName) \(employee.userLastName)" == employeeName { assignedEmployees.remove(employee)
                        return true
                    }
                    return false
                }
            }
                selectedButton?.setTitle("Assign an Employee", for: .normal)
            print(assignedEmployees)
            tableView.removeFromSuperview()
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let (inserted, _) = assignedEmployees.insert(userAccount)
        
        if !inserted {
            print(assignedEmployees)
            userExistAlert()
        } else if selectedButton?.currentTitle != "Assign an Employee" {
            let employeeName = selectedButton?.currentTitle
            let shouldRemoveEmployee = assignedEmployees.contains { employee in
                if "\(employee.userFirstName) \(employee.userLastName)" == employeeName { assignedEmployees.remove(employee)
                    return true
                }
                return false
            }
            
            if shouldRemoveEmployee {
                userAccount.checkEmployeeAvailablity { [weak self] isAvailable in
                    switch isAvailable {
                    case .available:
                        self?.selectedButton?.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
                    case .unavailable(let error):
                        self?.employeeIsNotAvailableAlert(message: error)
                    }
                }
            }
            print(assignedEmployees)
        } else {
            userAccount.checkEmployeeAvailablity { [weak self] isAvailable in
                switch isAvailable {
                case .available:
                    self?.selectedButton?.setTitle("\(userAccount.userFirstName) \(userAccount.userLastName)", for: .normal)
                case .unavailable(let error):
                    self?.employeeIsNotAvailableAlert(message: error)
                }
            }
            print(assignedEmployees)
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

extension ProjectEditTaskDetailViewController {
    
    private func editTask(completion: @escaping (AddTaskResult) -> Void) {
        guard let taskTitle = taskTitleTextField.text, let taskDescription = taskDescriptionTextView.text else {
            completion(.failure(message: "Task name and description must be filled. Please try again."))
            return
        }
        let startDate = taskStartDatePicker.date
        let endDate = taskEndDatePicker.date
        
        if taskTitle == "" || taskDescription == "" {
            completion(.failure(message: "Task name and description must be filled. Please try again."))
            return
        }
        
        if assignedEmployees.isEmpty {
            completion(.failure(message: "At least one employee must be assigned to the task. Please assign an employee and try again."))
            return
        }
        
        let isTaskExist = project?.tasks.contains { task in
            return task.title == taskTitle
            
        }
        
        if taskTitle != task?.title && (isTaskExist ?? false) {
            completion(.failure(message: "The task title exists. Please change the title and try again."))
        } else {
            if let taskSafe = task {
                taskSafe.editTaskTitle(title: taskTitle)
                taskSafe.editTaskDescription(description: taskDescription)
                taskSafe.editStartDate(startDate: startDate)
                taskSafe.editEndDate(endDate: endDate)
                taskSafe.editAssignedEmployees(employeeSet: assignedEmployees)
                
                completion(.success)
            }
        }
    
        
    }
}
