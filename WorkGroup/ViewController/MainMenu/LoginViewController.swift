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
    private lazy var userValidationService: UserValidationService? = {
        return UserValidationService()
    }()
    private lazy var companyValidation: CompanyValidationService? = {
        return CompanyValidationService()
    }()
    private lazy var loadingViewController: LoadingViewController? = {
        return LoadingViewController()
    }()
    private let textFieldStyle = TextFieldStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "LOGIN"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        setupTextFields()
    }
    
    private func setupTextFields() {
        textFieldStyle.styleTextField(companyRegistrationNumberTextField)
        textFieldStyle.styleTextField(loginPasswordTextField)
        textFieldStyle.styleTextField(loginEmailTextField)
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let registerNo = companyRegistrationNumberTextField.text, let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {
                return
            }
            
            guard let loadingVC = loadingViewController else {
                return
            }
            
            loadingVC.modalPresentationStyle = .fullScreen
            present(loadingVC, animated: false)
            
            self.companyValidation?.validateCompanyRegistrationNumber(registrationNumber: registerNo) { isCompany, foundCompany in
                if isCompany {
                    self.userValidationService?.validateUser(company: foundCompany, email: email, password: password) { isValidUser, isValidCompany, accountType in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            loadingVC.dismiss(animated: false) {
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
                                    self.presentAlert(message: Constant.Warning.Login.userNamePassInvalid)
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        loadingVC.dismiss(animated: false) {
                            self.presentAlert(message: Constant.Warning.Login.companyRegisterNoInvalid)
                        }
                    }
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Login.loginToAdmin {
            if let navController = segue.destination as? UINavigationController,
               let adminViewController = navController.topViewController as? AdminMainMenuViewController {
                if let registerNo = companyRegistrationNumberTextField.text {
                    isCompany(registerNo: registerNo) { company in
                        if let company = company {
                            adminViewController.company = company
                        }
                    }
                }
            }
        }
        if segue.identifier == Constant.Segue.Login.loginToManager {
            if let navController = segue.destination as? UINavigationController,
               let managerViewController = navController.topViewController as? ManagerAccountMenuViewController {
                if let registerNo = companyRegistrationNumberTextField.text {
                    isCompany(registerNo: registerNo) { company in
                        if let company = company {
                            managerViewController.company = company
                        }
                    }
                }
            }
        }
        if segue.identifier == Constant.Segue.Login.loginToEmployee {
            if let navController = segue.destination as? UINavigationController,
               let employeeViewController = navController.topViewController as? EmployeeMainMenuViewController {
                if let registerNo = companyRegistrationNumberTextField.text {
                    isCompany(registerNo: registerNo) { company in
                        if let company = company {
                            
                        }
                    }
                }
            }
        }
    }
}

extension LoginViewController {
    
    
    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func isCompany(registerNo: String, completion: @escaping (Company?) -> Void) {
        let companyValidation = CompanyValidationService()
        
        companyValidation.validateCompanyRegistrationNumber(registrationNumber: registerNo) { isCompanyFound, company in
            if isCompanyFound {
                completion(company)
            } else {
                completion(nil)
            }
        }
    }
}
