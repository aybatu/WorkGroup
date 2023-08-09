//
//  ManagerAccountMenuViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 10/06/2023.
//

import UIKit

class ManagerAccountMenuViewController: UIViewController {
    
    @IBOutlet weak var managerMenuNavBar: UINavigationItem!
    var company: Company?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerMenuNavBar.title = "MANAGER MENU"
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let companyValidationService = CompanyValidationService()
        companyValidationService.validateCompanyRegistrationNumber(registrationNumber: company?.registrationNumber ?? "") { isNetworkAvailable, isCompany, company in
            if isCompany {
                self.company = company
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
        if segue.identifier == Constant.Segue.Manager.MainMenu.managerMenuToCreateProject {
            if let createProjectVC = segue.destination as? ProjectDetailsViewController {
                if let company = self.company {
                    createProjectVC.company = company
                }
            }
        }
        if segue.identifier == Constant.Segue.Manager.MainMenu.managerViewToProjectList {
            if let projectListVC = segue.destination as? ProjectListEdit {
                projectListVC.company = company
            }
        }
        if segue.identifier == Constant.Segue.Manager.MainMenu.managerViewToScheduleMeeting {
            if let scheduleMeetingVC = segue.destination as? MeetingScheduleViewController {
                scheduleMeetingVC.company = company
            }
        }
        if segue.identifier == Constant.Segue.Manager.MainMenu.managerViewToMeetingList {
            if let meetingListVC = segue.destination as? MeetingEditListViewController {
                meetingListVC.company = company
            }
        }
        if segue.identifier == Constant.Segue.Manager.MainMenu.managerMenuToCompletedTaskRequestList {
            if let taskRequestListVC = segue.destination as? CompletedTaskListTableViewController {
                taskRequestListVC.company = company
            }
        }
    }
    
    func logout() {
        
        dismiss(animated: true, completion: nil)
    }
    
}
