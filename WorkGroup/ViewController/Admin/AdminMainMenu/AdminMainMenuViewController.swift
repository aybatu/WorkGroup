//
//  AdminMainMenuViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class AdminMainMenuViewController: UIViewController {
    
    var companyRegistrationNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure navigation bar with a logout button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
        
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
        // Perform logout actions here
        // For example, clear session data, reset app state, or navigate to the login screen
        // You can use `dismiss(animated:completion:)` to dismiss the current view controller or `popToRootViewController(animated:)` to navigate back to the root view controller
        
        // Example: Dismiss the current view controller and navigate back to the login screen
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Admin.mainMenuToCreateAccount {
            if let createAccountVC = segue.destination as? CreateUserAccountViewController {
                createAccountVC.companyRegistrationNo = companyRegistrationNumber
            }
        }
    }
}
