//
//  MeetingInviteEmployeeViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingInviteEmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var employeeSearchBar: UISearchBar!
    @IBOutlet weak var employeeListTableView: UITableView!
    
    var employeeList: [Employee] = []
    private var meeting: Meeting?
    var company: Company?
    private var failWithError: String?
    
    let meetingInviteValidator = MeetingInviteValidator()
    
    private var selectedEmployeeList: [Employee] = []
    private var filteredEmployeeList: [Employee] = []
    private var isSearching: Bool = false
    var meetingDetails: [String: Any?] = [
        Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetingDate: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: nil
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let companySafe = company {
            employeeList = Array(companySafe.employeeAccounts)
        }
        createMeeting()
        employeeSearchBar.delegate = self
        employeeListTableView.allowsMultipleSelection = true
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
        navigationItem.title = "Employee List"
    }
    override func viewWillAppear(_ animated: Bool) {
//        for employee in employeeList {
//            if let meetingSafe = meeting {
//                if employee.employeeMeetings.contains(meetingSafe) {
//                    selectedEmployeeList.append(employee)
//                }
//            }
//        }
//        employeeListTableView.reloadData()
    }
    
    private func createMeeting() {
        guard let meetingTitle = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingTitle] as? String,
              let meetingDescription = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetindDescription] as? String,
              let meetingDate = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingDate] as? Date,
              let meetingStartTime = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime] as? Date,
              let meetingEndTime = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime] as? Date
        else {
            return
        }
        
        meeting = Meeting(meetingDate: meetingDate, meetingStartTime: meetingStartTime, meetingEndTime: meetingEndTime, meetingTitle: meetingTitle, meetingDescription: meetingDescription)
        
        employeeListTableView.reloadData()
        
    }
    
    
    @IBAction func sendMeetingInviteButton(_ sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        
        present(loadingVC, animated: false)
        
        
        if selectedEmployeeList.count > 0 {
            guard let meetingSafe = meeting else {
                performSegue(withIdentifier: Constant.Segue.Manager.Meeting.ScheduleMeeting.sendMeetingRequestToFail, sender: self)
                return
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                if let companySafe = self?.company {
                    companySafe.addMeeting(meetingSafe)
                    
                }
                
            }
            loadingVC.dismiss(animated: false) { [weak self] in
                self?.performSegue(withIdentifier: Constant.Segue.Manager.Meeting.ScheduleMeeting.sendMeetingRequestTotSuccess, sender: self)
            }
        } else {
            loadingVC.dismiss(animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showAlert("At least an employee should be invited to create a meeting.")
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
        if let meetingSafe = meeting {
//            for employee in selectedEmployeeList {
//                if employee.employeeMeetings.contains(meetingSafe) {
//                    employee.removeMeeting(meeting: meetingSafe)
//                }
//            }
        }
        
        guard let navigationController = self.navigationController else {return}
        DispatchQueue.main.async {
            navigationController.popToRootViewController(animated: true)
        }
        
    }
    
    
    
}
extension MeetingInviteEmployeeViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredEmployeeList.count
        } else {
            return employeeList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.meetingEmployeListCellIdentifier, for: indexPath)
        guard let meetingSafe = meeting else {return cell}
        
        let employee: Employee
        if isSearching {
            employee = filteredEmployeeList[indexPath.row]
        } else {
            employee = employeeList[indexPath.row]
        }
        
        cell.textLabel?.text = "\(employee.userFirstName) \(employee.userLastName)"
        
        if employee.employeeInvitedMeetings.contains(meetingSafe) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let meetingSafe = meeting else {return}
        let employee: Employee
        if isSearching {
            employee = filteredEmployeeList[indexPath.row]
        } else {
            employee = employeeList[indexPath.row]
        }
        
        guard let meetingDate = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingDate] as? Date,
              let meetingStartTime = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime] as? Date
        else {
            return
        }
        
        if !employee.employeeInvitedMeetings.contains(meetingSafe) {
            meetingInviteValidator.isEmployeeAvailable(meetingDate: meetingDate, meetingStartTime: meetingStartTime, employee: employee) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        
                        
                        self?.selectedEmployeeList.append(employee)
                        employee.addMeeting(meeting: meetingSafe)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            tableView.reloadData()
                            
                        }
                        tableView.deselectRow(at: indexPath, animated: true)
                    case .employeeIsNotAvailable(let errorMsg):
                        tableView.deselectRow(at: indexPath, animated: true)
                        self?.showAlert(errorMsg)
                        
                    case .thereIsNoBreakTime(let errorMsg):
                        tableView.deselectRow(at: indexPath, animated: true)
                        self?.showAlert(errorMsg)
                        
                        
                    }
                }
            }
        } else if employee.employeeInvitedMeetings.contains(meetingSafe) && !selectedEmployeeList.contains(employee){
            employee.removeMeeting(meeting: meetingSafe)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                tableView.reloadData()
                
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if let index = selectedEmployeeList.firstIndex(of: employee) {
                selectedEmployeeList.remove(at: index)
                employee.removeMeeting(meeting: meetingSafe)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tableView.reloadData()
                    
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
                
            }
        }
        
    }
    
    private func showAlert(_ error: String) {
        let alertController = UIAlertController(title: "Fail", message: error, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
}

extension MeetingInviteEmployeeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterEmployeeList(with: searchText)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Get the updated text after applying the replacement
        let searchText = (searchBar.text as NSString?)?.replacingCharacters(in: range, with: text) ?? ""
        filterEmployeeList(with: searchText)
        return true
    }
    
    private func filterEmployeeList(with searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            employeeListTableView.reloadData()
        } else {
            isSearching = true
            let filteredList = employeeList.filter { employee in
                let fullName = "\(employee.userFirstName) \(employee.userLastName)"
                return fullName.lowercased().hasPrefix(searchText.lowercased())
            }
            filteredEmployeeList = filteredList
            employeeListTableView.reloadData()
        }
    }
}
