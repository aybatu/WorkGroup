//
//  AdminMainMenuViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class AdminMainMenuViewController: UIViewController {
    
    var company: RegisteredCompany?
    private var userAccounts: Set<UserAccount> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure navigation bar with a logout button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
        
    }
    @IBAction func createUserAccountButton(_ sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: false)
        
        
        getEmployeeList { userAccountsSet in
            loadingVC.dismiss(animated: false) {
                self.userAccounts = userAccountsSet
                self.performSegue(withIdentifier: Constant.Segue.Admin.mainMenuToCreateAccount, sender: self)
            }
        }
        
        
    }
    
    @IBAction func editEmployeeAccount(_ sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: false)
        
        
        getEmployeeList { userAccountsSet in
            loadingVC.dismiss(animated: false) {
                self.userAccounts = userAccountsSet
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
                createAccountVC.userAccounts = self.userAccounts
            }
        } else if segue.identifier == Constant.Segue.Admin.mainMenuToEditAccounts {
            if let editAccountsVC = segue.destination as? EditUserAccountListViewController {
                editAccountsVC.userAccounts = self.userAccounts
            }
        }
    }
    
    private func getEmployeeList(completion: @escaping (Set<UserAccount>) -> Void) {
        
        if let company = company {
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let userAccounts = company.userAccounts
                    var userAccountsSet: Set<UserAccount> = []
                    for userAccount in userAccounts {
                        userAccountsSet.insert(userAccount)
                    }
                    completion(userAccountsSet)
                }
                
            } else {
                print("Error, could not fetch company. Please try again.")
            }
       
        
        
    }
}
