//
//  ManagerAccountMenuViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 10/06/2023.
//

import UIKit

class ManagerAccountMenuViewController: UIViewController {
    
    @IBOutlet weak var managerMenuNavBar: UINavigationItem!
    var companyRegistrationNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerMenuNavBar.title = "MANAGER MENU"
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
        
        dismiss(animated: true, completion: nil)
    }
    
}
