//
//  EmployeeMainMenuViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeMainMenuViewController: UIViewController {
    var userAccount: Employee?
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
     
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userAccount = self.userAccount else {return}
        let companyValidationService = CompanyValidationService()
        companyValidationService.validateCompanyRegistrationNumber(registrationNumber: company?.registrationNumber ?? "") { isNetworkAvailable, isCompany, company in
            if isCompany {
                self.company = company
                let updatedEmployee = company?.employeeAccounts.first(where: {$0.emailAddress == userAccount.emailAddress})
                self.userAccount = updatedEmployee
            }
        }
    }
    
    @objc func logoutButtonTapped() {
        // Show a confirmation alert or perform any necessary logout actions
        let confirmationAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.logout()
        })
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Employee.MainMenu.employeeMenuToTasks {
            if let taskListVC = segue.destination as? EmployeeAssignedTaskListViewController {
                taskListVC.employee = userAccount
                taskListVC.company = company
            }
        }
        if segue.identifier == Constant.Segue.Employee.MainMenu.employeeMenuToMeetings {
            if let meetingListVC = segue.destination as? EmployeeMeetingListViewController {
                meetingListVC.employee = userAccount
            }
        }
    }
    
    func logout() {
        
        dismiss(animated: true, completion: nil)
    }
    
}

