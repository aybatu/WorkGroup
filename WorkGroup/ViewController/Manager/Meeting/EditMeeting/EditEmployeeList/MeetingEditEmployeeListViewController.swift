//
//  MeetingEditEmployeeListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditEmployeeListViewController: UIViewController {
    
    @IBOutlet weak var invitedEmployeeListTableView: UITableView!
    
    private var employeeList: [Employee] = []
    private let meetingInviteValidator = MeetingInviteValidator()

   
   
    var company: Company?
    var meeting: Meeting?
    private var selectedEmployeeList: [Employee] = []
    private var originalInvitedEmployeeList: [Employee]?
    var meetingDetails: [String: Any?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        navigationItem.title = "MEETING EMPLOYEE LIST"
        invitedEmployeeListTableView.delegate = self
        invitedEmployeeListTableView.dataSource = self
        invitedEmployeeListTableView.allowsMultipleSelection = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.invitedEmployeeListTableView.reloadData()
        }
    }
    
    private func loadData() {
        
//        if let companySafe = company {
//            employeeList = Array(companySafe.employeeAccounts)
//        }
//        if let meetingSafe = meeting {
//            for employee in employeeList {
//                if employee.employeeMeetings.contains(meetingSafe) {
//                    selectedEmployeeList.insert(employee)
//                }
//            }
//            originalInvitedEmployeeList = selectedEmployeeList
//        }
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.invitedEmployeeListTableView.reloadData()
//        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        
        present(loadingVC, animated: false)
        guard let meetingSafe = meeting,
              let  updatedMeetingTitle =  meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetingTitle] as? String,
              let updatedMeetingDescription = meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetindDescription] as? String,
              let updatedMeetingDate = meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetingDate] as? Date,
              let updatedMeetingStartTime = meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime] as? Date,
              let updatedMeetingEndTime = meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime] as? Date else
        {
            performSegue(withIdentifier: Constant.Segue.Manager.Meeting.EditMeeting.editInvitedEmployeeToFail, sender: self)
            return
            
        }
        
        meetingSafe.meetingTitle = updatedMeetingTitle
        meetingSafe.meetingDescription = updatedMeetingDescription
        meetingSafe.meetingDate = updatedMeetingDate
        meetingSafe.meetingStartTime = updatedMeetingStartTime
        meetingSafe.meetingEndTime = updatedMeetingEndTime
     
        if selectedEmployeeList.count > 0 {
            
            loadingVC.dismiss(animated: false) { [weak self] in
                
                self?.performSegue(withIdentifier: Constant.Segue.Manager.Meeting.EditMeeting.editInvitedEmployeeToSuccess, sender: self)
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
        
        guard let meetingSafe = meeting, let originalInvitedEmployeeSafe = originalInvitedEmployeeList else {return}
        for employee in selectedEmployeeList {
            employee.removeMeeting(meeting: meetingSafe)
        }
        
        for employee in originalInvitedEmployeeSafe {
            if !employee.employeeInvitedMeetings.contains(meetingSafe) {
                employee.addMeeting(meeting: meetingSafe)
            }
        }


        DispatchQueue.main.async { [weak self] in
            guard let navigationController = self?.navigationController else { return }
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}

extension MeetingEditEmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return employeeList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = invitedEmployeeListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.editMeetingEmployeeListCellIdentifier, for: indexPath)
        guard let meetingSafe = meeting else {return cell}
        
        let employee = employeeList[indexPath.row]
        
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
        let employee = employeeList[indexPath.row]
        
        
        guard let meetingDate = meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetingDate] as? Date,
              let meetingStartTime = meetingDetails?[Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime] as? Date
        else {
            return
        }
        
        if !employee.employeeInvitedMeetings.contains(meetingSafe) {
            meetingInviteValidator.isEmployeeAvailable(meetingDate: meetingDate, meetingStartTime: meetingStartTime, employee: employee) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
//                        self?.selectedEmployeeList.insert(employee)
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
