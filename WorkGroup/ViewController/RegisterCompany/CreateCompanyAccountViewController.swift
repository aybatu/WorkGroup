//
//  CreateCompanyAccountViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 17/06/2023.
//

import UIKit

class CreateCompanyAccountViewController: UIViewController {
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var emailAddressConfirmTextField: UITextField!
    @IBOutlet weak var confirmEmailAddressLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var registerCompanyButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var surnameLabel: UILabel!
    
    private var textFields: [UITextField] = []
    
    private var isCompany = false
    private var isEmailValid = false
    private var isEmailMatch = false
    private var isPasswordValid = false
    private var isPasswordMatch = false
    private var isFirstname = false
    private var isSurname = false
    
    private var registeredCompany: Company?
    private var isFailWithError: String?
    private let textFieldStyle = TextFieldStyle()
    private let loadingVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCompanyButton.isEnabled = false
        setupTextFields()
        
        setupTextFields()
        loadingVC.modalPresentationStyle = .overCurrentContext
        
        navigationController?.title = "COMPANY REGISTRATION"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        loadingVC.modalPresentationStyle = .overCurrentContext
        
    }
    
    private func setupTextFields() {
        textFields = [companyNameTextField, firstNameTextField, surnameTextField, emailAddressTextField, emailAddressConfirmTextField, passwordTextField, confirmPasswordTextField]
        for textField in textFields {
            textField.delegate = self
            textFieldStyle.styleTextField(textField)
        }
    }
    
    
    @IBAction func registerCompanyButton(_ sender: UIButton) {
    
        registerCompanyWithAdminAccount { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.loadingVC.dismiss(animated: false) {
                        self.performSegue(withIdentifier: Constant.Segue.RegisterCompany.createAccountToSuccess, sender: self)
                    }
                }
            case .failure(let errorMessage):
                self.isFailWithError = errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.loadingVC.dismiss(animated: false) {
                        self.performSegue(withIdentifier: Constant.Segue.RegisterCompany.createAccountToFail, sender: self)
                    }
                    
                }
                    
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.RegisterCompany.createAccountToSuccess {
            if let createAccountSuccessVC = segue.destination as? CreateCompanyAccountSuccessViewController {
                if let registrationNumber = registeredCompany?.registrationNumber {
                    
                    createAccountSuccessVC.registrationNo = registrationNumber
                }
            }
        } else if segue.identifier == Constant.Segue.RegisterCompany.createAccountToFail {
            if let createAccountFailVC = segue.destination as? CreateCompanyAccountFailViewController {
                if let errorMessageSafe = isFailWithError {
                    createAccountFailVC.errorMessage = errorMessageSafe
                }
            }
        }
    }
    
    
    
    
    private func enableRegistrationButton() {
        DispatchQueue.main.async { [self] in
            registerCompanyButton.isEnabled = isCompany && isEmailMatch && isEmailValid && isPasswordValid && isPasswordMatch && isFirstname && isSurname
        }
    }
}

extension CreateCompanyAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let currentIndex = textFields.firstIndex(of: textField), currentIndex < textFields.count - 1 {
            let nextIndex = currentIndex + 1
            let nextTextField = textFields[nextIndex]
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        let companyAccountValidator = CompanyAccountValidator()
        
        switch textField {
        case firstNameTextField:
            isFirstname = companyAccountValidator.validateName(updatedText, employeeNameTextField: firstNameTextField, employeeNameLabel: firstNameLabel)
        case surnameTextField:
            isSurname = companyAccountValidator.validateSurname(updatedText, employeeSurnameTextField: surnameTextField, employeeSurnameLabel: surnameLabel)
        case companyNameTextField:
            isCompany = companyAccountValidator.checkForCompanyName(updatedText, companyNameTextField: companyNameTextField, companyNameLabel: companyNameLabel)
        case emailAddressTextField:
            isEmailValid = companyAccountValidator.validateEmail(updatedText, emailAddressTextField: emailAddressTextField, emailAddressLabel: emailAddressLabel)
            isEmailMatch = companyAccountValidator.doEmailsMatch(updatedText, emailAddressConfirmTextField.text ?? "", confirmEmailAddressTextField: emailAddressConfirmTextField, confirmEmailAddressLabel: confirmEmailAddressLabel)
        case emailAddressConfirmTextField:
            isEmailMatch = companyAccountValidator.doEmailsMatch(emailAddressTextField.text ?? "", updatedText, confirmEmailAddressTextField: emailAddressConfirmTextField, confirmEmailAddressLabel: confirmEmailAddressLabel)
        case passwordTextField:
            isPasswordValid = companyAccountValidator.validatePassword(updatedText, passwordTextField: passwordTextField, passwordLabel: passwordLabel)
            isPasswordMatch = companyAccountValidator.doPasswordsMatch(updatedText, confirmPasswordTextField.text ?? "", confirmPasswordTextField: confirmPasswordTextField, confirmPasswordLabel: confirmPasswordLabel)
        case confirmPasswordTextField:
            isPasswordMatch = companyAccountValidator.doPasswordsMatch(passwordTextField.text ?? "", updatedText, confirmPasswordTextField: confirmPasswordTextField, confirmPasswordLabel: confirmPasswordLabel)
        default:
            break
        }
        
        enableRegistrationButton()
        
        return true
    }
    
    
    
}


extension CreateCompanyAccountViewController {
    func registerCompanyWithAdminAccount(completion: @escaping(AccountCreationResult) ->Void) {
        
        guard let emailAddress = emailAddressTextField.text,
              let companyName = companyNameTextField.text,
              let password = passwordTextField.text,
              let firstName = firstNameTextField.text,
              let surname = surnameTextField.text else {
            completion(.failure(message: "Missing required fields."))
            return
        }
        
        let createdOwnerAccount = Admin(accountType: .ADMIN, emailAddress: emailAddress, userFirstName: firstName, userLastName: surname, password: password)
        let registeredCompany = Company(companyName: companyName, ownerAccount: createdOwnerAccount)
        
        self.registeredCompany = registeredCompany
        
        loadingVC.setDatabaseAction {
            let registrationService = RegistrationService()
            registrationService.register(company: registeredCompany) { result, registrationNo, errorMsg in
                if result {
                    if let registrationNoSafe = registrationNo {
                        registeredCompany.registrationNumber = registrationNoSafe
                       
                        completion(.success)
                    } else {
                        completion(.failure(message: errorMsg ?? ""))
                    }
                } else {
                    completion(.failure(message: errorMsg ?? ""))
                }
            }
        }
        present(loadingVC, animated: false)
    }
}

