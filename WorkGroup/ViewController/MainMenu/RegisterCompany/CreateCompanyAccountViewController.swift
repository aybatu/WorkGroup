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
    
    private let defaultCompanyLabelText = "Please enter your company name."
    private let defaultEmailLabelText = "Please enter admin account email address."
    private let defaultConfirmEmailAddressLabelText = "Please confirm your email address."
    private let defaultPasswordLabelText = "Please enter at least an 8-character password, including at least one uppercase, one number, and one special character."
    private let defaultConfirmPasswordLabelText = "Please confirm your password."
    private let defaultFirstNameTextLabel = "Please enter your first name."
    private let defaultFSurnameTextLabel = "Please enter your surname."
    
    private var isCompany = false
    private var isEmailValid = false
    private var isEmailMatch = false
    private var isPasswordValid = false
    private var isPasswordMatch = false
    private var isFirstname = false
    private var isSurname = false
  
    private var registeredCompany: RegisteredCompany?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCompanyButton.isEnabled = false
        setupTextFields()
        setupLabels()
        textFields = [companyNameTextField, firstNameTextField, surnameTextField, emailAddressTextField, emailAddressConfirmTextField, passwordTextField, confirmPasswordTextField]
        
        navigationController?.title = "Register Company"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
  
    
    
    @IBAction func registerCompanyButton(_ sender: UIButton) {
        guard let companyName = companyNameTextField.text,
              let adminEmailAddress = emailAddressTextField.text,
              let password = passwordTextField.text, let firstName = firstNameTextField.text, let surname = surnameTextField.text else {
            return
        }
        
        self.registeredCompany = RegisteredCompany(companyName: companyName)
        let createdAccount = UserAccount(accountType: AccountTypes.ADMIN, emailAddress: adminEmailAddress, userFirstName: firstName, userLastName: surname, password: password)
        registeredCompany?.addUserAccount(createdAccount)
      
        TemporaryDatabase.registeredCompanies.append(registeredCompany!)
        
        performSegue(withIdentifier: Constant.Segue.RegisterCompany.createAccountToSuccess, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.RegisterCompany.createAccountToSuccess {
            if let createAccountSuccessVC = segue.destination as? CreateCompanyAccountSuccessViewController {
                if let registrationNumber = registeredCompany?.registrationNumber {
                   
                    createAccountSuccessVC.registrationNo = registrationNumber
                }
            }
        }
    }
    
    
    private func setupTextFields() {
        let textFields = [companyNameTextField, emailAddressTextField, emailAddressConfirmTextField, passwordTextField, confirmPasswordTextField, firstNameTextField, surnameTextField]
        for textField in textFields {
            textField?.delegate = self
        }
    }
    
    private func setupLabels() {
        companyNameLabel.text = defaultCompanyLabelText
        emailAddressLabel.text = defaultEmailLabelText
        confirmEmailAddressLabel.text = defaultConfirmEmailAddressLabelText
        passwordLabel.text = defaultPasswordLabelText
        confirmPasswordLabel.text = defaultConfirmPasswordLabelText
        firstNameLabel.text = defaultFirstNameTextLabel
        surnameLabel.text = defaultFSurnameTextLabel
    }
    
    private func enableRegistrationButton() {
        registerCompanyButton.isEnabled = isCompany && isEmailMatch && isEmailValid && isPasswordValid && isPasswordMatch && isFirstname && isSurname
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            checkForFirstName()
        case surnameTextField:
            checkForSurname()
        case companyNameTextField:
            checkForCompanyName()
        case emailAddressTextField:
            validateEmail()
        case emailAddressConfirmTextField:
            validateEmailsMatch()
        case passwordTextField:
            validatePassword()
        case confirmPasswordTextField:
            validatePasswordsMatch()
        default:
            break
        }
        enableRegistrationButton()
    }
    
    private func checkForFirstName() {
        let isEmpty = firstNameTextField.text?.isEmpty ?? true
        firstNameLabel.text = isEmpty ? "Please enter your first name." : defaultCompanyLabelText
        firstNameLabel.textColor = isEmpty ? .red : nil
        firstNameTextField.layer.borderWidth = 1.0
        firstNameTextField.layer.borderColor = isEmpty ? UIColor.red.cgColor : UIColor.green.cgColor
        isFirstname = !isEmpty
    }
    
    private func checkForSurname() {
        let isEmpty = surnameTextField.text?.isEmpty ?? true
        surnameLabel.text = isEmpty ? "Please enter a company name." : defaultCompanyLabelText
        surnameLabel.textColor = isEmpty ? .red : nil
        surnameTextField.layer.borderWidth = 1.0
        surnameTextField.layer.borderColor = isEmpty ? UIColor.red.cgColor : UIColor.green.cgColor
        isSurname = !isEmpty
    }
    
    private func checkForCompanyName() {
        let isEmpty = companyNameTextField.text?.isEmpty ?? true
        companyNameLabel.text = isEmpty ? "Please enter a company name." : defaultCompanyLabelText
        companyNameLabel.textColor = isEmpty ? .red : nil
        companyNameTextField.layer.borderWidth = 1.0
        companyNameTextField.layer.borderColor = isEmpty ? UIColor.red.cgColor : UIColor.green.cgColor
        isCompany = !isEmpty
    }
    
    private func validateEmail() {
        guard let email = emailAddressTextField.text else { return }
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        emailAddressTextField.layer.borderWidth = 1.0
        emailAddressTextField.layer.borderColor = emailPredicate.evaluate(with: email) ? UIColor.green.cgColor : UIColor.red.cgColor
        emailAddressLabel.text = emailPredicate.evaluate(with: email) ? defaultEmailLabelText : Constant.Warning.Email.invalidEmailFormat
        emailAddressLabel.textColor = emailPredicate.evaluate(with: email) ? nil : .red
        isEmailValid = !email.isEmpty && emailPredicate.evaluate(with: email)
    }
    
    private func validateEmailsMatch() {
        let email = emailAddressTextField.text ?? ""
        let confirmEmail = emailAddressConfirmTextField.text ?? ""
        
        emailAddressConfirmTextField.layer.borderWidth = 1.0
        emailAddressConfirmTextField.layer.borderColor = email == confirmEmail ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmEmailAddressLabel.text = email == confirmEmail ? defaultConfirmEmailAddressLabelText : Constant.Warning.Email.emailMatchFail
        confirmEmailAddressLabel.textColor = email == confirmEmail ? nil : .red
        isEmailMatch = !confirmEmail.isEmpty && email == confirmEmail
    }
    
    private func validatePassword() {
        guard let password = passwordTextField.text else { return }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = passwordPredicate.evaluate(with: password) ? UIColor.green.cgColor : UIColor.red.cgColor
        passwordLabel.text = passwordPredicate.evaluate(with: password) ? defaultPasswordLabelText : Constant.Warning.Password.passwordFormatInvalid
        passwordLabel.textColor = passwordPredicate.evaluate(with: password) ? nil : .red
        isPasswordValid = !password.isEmpty && passwordPredicate.evaluate(with: password)
    }
    
    private func validatePasswordsMatch() {
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        confirmPasswordTextField.layer.borderWidth = 1.0
        confirmPasswordTextField.layer.borderColor = password == confirmPassword ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmPasswordLabel.text = password == confirmPassword ? defaultConfirmPasswordLabelText : Constant.Warning.Password.passwordDoNotMatch
        confirmPasswordLabel.textColor = password == confirmPassword ? nil : .red
        isPasswordMatch = !confirmPassword.isEmpty && password == confirmPassword
    }
}
