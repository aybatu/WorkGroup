//
//  AccountValidator.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 25/06/2023.
//

import UIKit


protocol AccountValidator {
    func validateName(_ name: String, employeeNameTextField: UITextField, employeeNameLabel: UILabel ) -> Bool
    
    func validateSurname(_ surname: String, employeeSurnameTextField: UITextField, employeeSurnameLabel: UILabel) -> Bool
    
    func validateEmail(_ email: String, emailAddressTextField: UITextField, emailAddressLabel: UILabel) -> Bool
    
    func doEmailsMatch(_ email: String, _ confirmEmail: String, confirmEmailAddressTextField: UITextField, confirmEmailAddressLabel: UILabel) -> Bool
    
    func validatePassword(_ password: String, passwordTextField: UITextField, passwordLabel: UILabel) -> Bool
    
    func doPasswordsMatch(_ password: String, _ confirmPassword: String, confirmPasswordTextField: UITextField, confirmPasswordLabel: UILabel) -> Bool
}

extension AccountValidator {
    func doPasswordsMatch(_ password: String, _ confirmPassword: String, confirmPasswordTextField: UITextField, confirmPasswordLabel: UILabel) -> Bool {
        let doMatch = password == confirmPassword
        
        confirmPasswordTextField.layer.borderWidth = 1.0
        confirmPasswordTextField.layer.borderColor = doMatch ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmPasswordLabel.text = doMatch ? "Passwords match." : "Passwords do not match."
        confirmPasswordLabel.textColor = doMatch ? nil : .red
        
        return doMatch
    }
    
    func validateName(_ name: String, employeeNameTextField: UITextField, employeeNameLabel: UILabel ) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !trimmedName.isEmpty
        
        employeeNameTextField.layer.borderWidth = 1.0
        employeeNameTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        employeeNameLabel.text = isValid ? "Employee Name" : "Employee name is required"
        employeeNameLabel.textColor = isValid ? nil : .red
        
        return isValid
    }
    
    func validateSurname(_ surname: String, employeeSurnameTextField: UITextField, employeeSurnameLabel: UILabel) -> Bool {
        let trimmedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !trimmedSurname.isEmpty
        
        employeeSurnameTextField.layer.borderWidth = 1.0
        employeeSurnameTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        employeeSurnameLabel.text = isValid ? "Employee surname." : "Employee surname is required."
        employeeSurnameLabel.textColor = isValid ? nil : .red
        
        return isValid
    }
    
    func validateEmail(_ email: String, emailAddressTextField: UITextField, emailAddressLabel: UILabel) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: email)
        
        emailAddressTextField.layer.borderWidth = 1.0
        emailAddressTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        emailAddressLabel.text = isValid ? "Email address." : "Please enter a valid email address. Example: jdoe@company.com"
        emailAddressLabel.textColor = isValid ? nil : .red
        
        return isValid
    }
    
    func doEmailsMatch(_ email: String, _ confirmEmail: String, confirmEmailAddressTextField: UITextField, confirmEmailAddressLabel: UILabel) -> Bool {
        let doMatch = email == confirmEmail
        
        confirmEmailAddressTextField.layer.borderWidth = 1.0
        confirmEmailAddressTextField.layer.borderColor = doMatch ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmEmailAddressLabel.text = doMatch ? "Email addresses match." : "Email addresses do not match."
        confirmEmailAddressLabel.textColor = doMatch ? nil : .red
        
        return doMatch
    }
    
    func validatePassword(_ password: String, passwordTextField: UITextField, passwordLabel: UILabel) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValid = passwordPredicate.evaluate(with: password)
        
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        passwordLabel.text = isValid ? "Please enter a valid password." : "Please enter a valid password. Minimum length 8 characters including at least one uppercase, one number, and one special character."
        passwordLabel.textColor = isValid ? nil : .red
        
         return isValid
    }
}
