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
    
    private var companyRegisterNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "LOGIN"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let password = loginPasswordTextField.text,
              let userName = loginEmailTextField.text,
              let registerNo = companyRegistrationNumberTextField.text else {
            return
        }
        
        let loadingViewController = LoadingViewController()
        loadingViewController.emailAddress = userName
        loadingViewController.password = password
        loadingViewController.registrationNumber = registerNo
        loadingViewController.modalPresentationStyle = .fullScreen
        present(loadingViewController, animated: false)
        
        performAuthentication { isValidUser, isValidCompany, accountType in
            loadingViewController.dismiss(animated: false) {
                
                if isValidUser {
                    self.companyRegisterNumber = registerNo
                    switch accountType {
                    case .ADMIN:
                        self.performSegue(withIdentifier: Constant.Segue.Login.loginToAdmin, sender: self)
                    case .MANAGER:
                        self.performSegue(withIdentifier: Constant.Segue.Login.loginToManager, sender: self)
                    case .EMPLOYEE:
                        self.performSegue(withIdentifier: Constant.Segue.Login.loginToEmployee, sender: self)
                    case .none:
                        break
                    }
                } else if isValidCompany {
                    self.presentAlert(message: Constant.Warning.Login.userNamePassInvalid )
                } else {
                    self.presentAlert(message: Constant.Warning.Login.companyRegisterNoInvalid)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Login.loginToAdmin {
            if let navController = segue.destination as? UINavigationController,
               let adminViewController = navController.topViewController as? AdminMainMenuViewController {
                if let registerNo = companyRegistrationNumberTextField.text {
                    adminViewController.companyRegistrationNumber = registerNo
                    
                }
            }
        } else if segue.identifier == Constant.Segue.Login.loginToManager {
            if let navController = segue.destination as? UINavigationController,
               let managerViewController = navController.topViewController as? ManagerAccountMenuViewController {
                if let registerNo = companyRegistrationNumberTextField.text {
                    managerViewController.companyRegistrationNumber = registerNo
                    
                }
            }
        } else if segue.identifier == Constant.Segue.Login.loginToEmployee {
            if let navController = segue.destination as? UINavigationController,
               let employeeViewController = navController.topViewController as? EmployeeMainMenuViewController {
                if let registerNo = companyRegistrationNumberTextField.text {
                    employeeViewController.companyRegistrationNumber = registerNo
                    
                }
            }
        }
    }
}

extension LoginViewController {
    func performAuthentication(completion: @escaping (Bool, Bool, AccountTypes?) -> Void) {
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text,
           let registerNumber = companyRegistrationNumberTextField.text {
            
            let registeredCompanies = TemporaryDatabase.registeredCompanies
            let searchRegisteredCompany = Search<RegisteredCompany>()
            let foundCompany = searchRegisteredCompany.binarySearch(registeredCompanies, target: registerNumber, keyPath: \.registrationNumber)
            
            if foundCompany == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let isValidUser = false
                    let isValidCompany = false
                    let accountType: AccountTypes? = nil
                    completion(isValidUser, isValidCompany, accountType)
                }
            } else {
                let searchUserAccount = Search<UserAccount>()
                let foundUserAccount = searchUserAccount.binarySearch(foundCompany!.userAccounts, target: email, keyPath: \.emailAddress)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    var isValidUser = false
                    var accountType: AccountTypes?
                    let isValidCompany = true
                    if let userAccount = foundUserAccount, userAccount.password == password {
                        isValidUser = true
                        
                        
                        switch userAccount.accountType {
                        case .ADMIN:
                            accountType = .ADMIN
                        case .MANAGER:
                            accountType = .MANAGER
                        case .EMPLOYEE:
                            accountType = .EMPLOYEE
                        }
                    }
                    
                    completion(isValidUser, isValidCompany, accountType)
                }
            }
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
