//
//  LoginViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 10/06/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var companyRegistrationNumberTextField: UITextField!
    

    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
     
    }
    
    @IBAction func login(_ sender: Any) {
        var companyRN = false
        if(companyRegistrationNumberTextField.text == "0001") {
            companyRN = true
        }
        if(isManager() && companyRN) {
            performSegue(withIdentifier: "LoginViewToManager", sender: nil)
        }else if(isAdmin() && companyRN) {
            performSegue(withIdentifier: "LoginToAdminMenu", sender: nil)
        }else if(isEmployee() && companyRN) {
            performSegue(withIdentifier: "LoginViewToEmployee", sender: nil)
        }
    }
   
    
    func isManager() -> Bool {
        if(loginEmailTextField.text == "manager" && loginPasswordTextField.text == "manager") {
            return true
        } else {
            return false
        }
    }
    
    func isAdmin()->Bool {
        if(loginEmailTextField.text == "admin" && loginPasswordTextField.text == "admin") {
            return true
        } else {
            return false
        }
    }
    
    func isEmployee() -> Bool {
        if(loginEmailTextField.text == "employee" && loginPasswordTextField.text == "employee") {
            return true
        } else {
            return false
        }
    }
}
