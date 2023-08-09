//
//  LoginViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 10/06/2023.
//

import UIKit



class LoginViewController: UIViewController {
    
    @IBOutlet weak var rememberMeButton: UIButton!
    
    @IBOutlet weak var companyRegistrationNumberTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    
    private var companyRegisterNumber: String?
    private var userAccount: Employee?
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
        loadRememberedData()
    
    }
    
    @IBAction func rememberMeTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
      
        if sender.isSelected {
            rememberMeButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
           
            
        } else {
            rememberMeButton.setImage(UIImage(systemName: "squareshape"), for: .normal)
            
        }
       
       
    }
    private func setupTextFields() {
        textFieldStyle.styleTextField(companyRegistrationNumberTextField)
        textFieldStyle.styleTextField(loginPasswordTextField)
        textFieldStyle.styleTextField(loginEmailTextField)
    }
    
    private func loadRememberedData() {
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: "rememberedUsername") {
            loginEmailTextField.text = username
        }
        if let password = defaults.string(forKey: "rememberedPassword") {
            loginPasswordTextField.text = password
        }
        if let registrationNumber = defaults.string(forKey: "rememberedRegistrationNumber") {
            companyRegistrationNumberTextField.text = registrationNumber
        }
    }
    
    private func saveRememberedData() {
        let defaults = UserDefaults.standard
        defaults.set(loginEmailTextField.text, forKey: "rememberedUsername")
        defaults.set(loginPasswordTextField.text, forKey: "rememberedPassword")
        defaults.set(companyRegistrationNumberTextField.text, forKey: "rememberedRegistrationNumber")
        defaults.synchronize() // Optional, but can be used to ensure data is immediately saved
    }
    
    @IBAction func login(_ sender: UIButton) {
        if(rememberMeButton.isSelected) {
            saveRememberedData()
        }
        guard let registerNo = companyRegistrationNumberTextField.text, let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {
            return
        }
        
        guard let loadingVC = loadingViewController else {
            return
        }
        
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: false)
        
        self.companyValidation?.validateCompanyRegistrationNumber(registrationNumber: registerNo) { isNetworkAvailable, isCompany, foundCompany in
            if isCompany {
                self.userValidationService?.validateUser(company: foundCompany, email: email, password: password) { isValidUser, isValidCompany, accountType in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        loadingVC.dismiss(animated: false) {
                            if isValidUser {
                                self.companyRegisterNumber = registerNo
                                switch accountType {
                                case .ADMIN:
                                    self.performSegue(withIdentifier: Constant.Segue.Login.loginToAdmin, sender: self)
                                case .MANAGER:
                                    self.performSegue(withIdentifier: Constant.Segue.Login.loginToManager, sender: self)
                                case .EMPLOYEE:
                                    guard let foundCompany = foundCompany else {return}
                                    for employee in foundCompany.employeeAccounts {
                                        if employee.emailAddress == email {
                                            self.userAccount = employee
                                        }
                                    }
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
            } else if !isNetworkAvailable {
                DispatchQueue.main.async {
                    loadingVC.dismiss(animated: false) {
                        self.presentAlert(message: Constant.Warning.Login.notConnected)
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
                        if let company = company, let userAccount = self.userAccount {
                            employeeViewController.company = company
                            employeeViewController.userAccount = userAccount
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
        
        companyValidation.validateCompanyRegistrationNumber(registrationNumber: registerNo) { isNetworkAvailable, isCompanyFound, company in
            if isCompanyFound {
                completion(company)
            } else {
                completion(nil)
            }
        }
    }
}
