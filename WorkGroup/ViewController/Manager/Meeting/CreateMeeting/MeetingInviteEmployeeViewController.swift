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
    
    var employeeList: [UserAccount] = []
    
    var company: RegisteredCompany?
    private var failWithError: String?
    
    let meetingInviteValidator = MeetingInviteValidator()
    
    private var selectedEmployeeList: [UserAccount] = []
    private var filteredEmployeeList: [UserAccount] = []
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
            employeeList = companySafe.userAccounts
        }
        employeeSearchBar.delegate = self
        employeeListTableView.allowsMultipleSelection = true
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
        
        navigationItem.title = "Employee List"
    }
    
    @IBAction func sendMeetingInviteButton(_ sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        
        present(loadingVC, animated: false)
        
        guard let meetingTitle = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingTitle] as? String,
              let meetingDescription = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetindDescription] as? String,
              let meetingDate = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingDate] as? Date,
              let meetingStartTime = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime] as? Date,
              let meetingEndTime = meetingDetails[Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime] as? Date
        else {
            performSegue(withIdentifier: Constant.Segue.Manager.Meeting.sendMeetingRequestToFail, sender: self)
            return
        }
        if selectedEmployeeList.count > 0 {
            let selecteEmployeeSet = Set(selectedEmployeeList)
            let newMeeting = Meeting(_meetingDate: meetingDate, _meetingStartTime: meetingStartTime, _meetingEndTime: meetingEndTime, _meetingTitle: meetingTitle, _meetingDescription: meetingDescription, _invitedEmployeeList: selecteEmployeeSet)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                
                for employee in self!.selectedEmployeeList {
                    employee.addMeeting(meeting: newMeeting)
                    employee.isSelected = false
                   
                    
                }
            }
            loadingVC.dismiss(animated: false) { [weak self] in
                
                self?.performSegue(withIdentifier: Constant.Segue.Manager.Meeting.sendMeetingRequestTotSuccess, sender: self)
        }
        
        
        } else {
            showAlert("At least an employee should be invited to create a meeting.")
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
        navigationController.popToRootViewController(animated: true)
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
        
        let employee: UserAccount
        if isSearching {
            employee = filteredEmployeeList[indexPath.row]
        } else {
            employee = employeeList[indexPath.row]
        }
        
        cell.textLabel?.text = "\(employee.userFirstName) \(employee.userLastName)"
        
        if employee.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee: UserAccount
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
        
        if employee.isSelected == false {
            meetingInviteValidator.isEmployeeAvailable(meetingDate: meetingDate, meetingStartTime: meetingStartTime, employee: employee) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        
                        employee.isSelected = true
                        self?.selectedEmployeeList.append(employee)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            tableView.reloadData()
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                        
                    case .employeeIsNotAvailable(let errorMsg):
                        tableView.deselectRow(at: indexPath, animated: true)
                        self?.showAlert(errorMsg)
                      
                    case .thereIsNoBreakTime(let errorMsg):
                        tableView.deselectRow(at: indexPath, animated: true)
                        self?.showAlert(errorMsg)
                        
                    }
                }
            }
            
        } else {
            if let index = selectedEmployeeList.firstIndex(of: employee) {
                selectedEmployeeList.remove(at: index)
                employee.isSelected = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    tableView.reloadData()
                    tableView.deselectRow(at: indexPath, animated: true)
                }
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
