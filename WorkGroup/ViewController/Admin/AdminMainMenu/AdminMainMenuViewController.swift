//
//  AdminMainMenuViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class AdminMainMenuViewController: UIViewController {
    
    var company: Company?
    private var userAccounts = [any UserAccount]()
    private let companyValidationService = CompanyValidationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure navigation bar with a logout button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        companyValidationService.validateCompanyRegistrationNumber(registrationNumber: company?.registrationNumber ?? "") { isNetworkAvailable, isCompany, company in
            if isCompany {
                self.company = company
            }
        }
    }
    @IBAction func createUserAccountButton(_ sender: UIButton) {
 
        self.performSegue(withIdentifier: Constant.Segue.Admin.mainMenuToCreateAccount, sender: self)
        
    }
    
    @IBAction func editEmployeeAccount(_ sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: false)
        
        
        getUserAccountList { userAccounts in
            loadingVC.dismiss(animated: false) {
                self.userAccounts = userAccounts
                self.performSegue(withIdentifier: Constant.Segue.Admin.mainMenuToEditAccounts, sender: self)
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
    
    func logout() {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Admin.mainMenuToCreateAccount {
            if let createAccountVC = segue.destination as? CreateUserAccountViewController {
                createAccountVC.company = company
            }
        } else if segue.identifier == Constant.Segue.Admin.mainMenuToEditAccounts {
            if let editAccountsVC = segue.destination as? EditUserAccountListViewController {
                editAccountsVC.company = company
                editAccountsVC.userAccounts = userAccounts
            }
        }
    }
    
    private func getUserAccountList(completion: @escaping ([any UserAccount]) -> Void) {
        var userAccounts = [any UserAccount]()
           
           if let company = company {
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   let employeeAccounts = company.employeeAccounts
                   let managerAccounts = company.managerAccounts
                   
                   userAccounts.append(contentsOf: employeeAccounts)
                   userAccounts.append(contentsOf: managerAccounts)
                   
                   completion(userAccounts)
               }
           } else {
               print("Error: Could not fetch company. Please try again.")
           }
    }
}
