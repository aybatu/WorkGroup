//
//  TextFieldAccountValidatorView.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import UIKit

class TextFieldAccountValidatorView {
    func doPasswordsMatch(doMatch: Bool, confirmPasswordTextField: UITextField, confirmPasswordLabel: UILabel) {
   
        confirmPasswordTextField.layer.borderWidth = 1.0
        confirmPasswordTextField.layer.borderColor = doMatch ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmPasswordLabel.text = doMatch ? "Passwords match." : "Passwords do not match."
        confirmPasswordLabel.textColor = doMatch ? nil : .red
      
    }
    
    func validateName(isValid: Bool, employeeNameTextField: UITextField, employeeNameLabel: UILabel ) {
       
        employeeNameTextField.layer.borderWidth = 1.0
        employeeNameTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        employeeNameLabel.text = isValid ? "Employee Name" : "Employee name is required"
        employeeNameLabel.textColor = isValid ? nil : .red
     
    }
    
    func validateSurname(isValid: Bool, employeeSurnameTextField: UITextField, employeeSurnameLabel: UILabel) {
     
        employeeSurnameTextField.layer.borderWidth = 1.0
        employeeSurnameTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        employeeSurnameLabel.text = isValid ? "Employee surname." : "Employee surname is required."
        employeeSurnameLabel.textColor = isValid ? nil : .red
   
    }
    
    func validateEmail(isValid: Bool, emailAddressTextField: UITextField, emailAddressLabel: UILabel) {
     
        emailAddressTextField.layer.borderWidth = 1.0
        emailAddressTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        emailAddressLabel.text = isValid ? "Email address." : "Please enter a valid email address. Example: jdoe@company.com"
        emailAddressLabel.textColor = isValid ? nil : .red
    
    }
    
    func doEmailsMatch(doMatch: Bool, confirmEmailAddressTextField: UITextField, confirmEmailAddressLabel: UILabel) {
        confirmEmailAddressTextField.layer.borderWidth = 1.0
        confirmEmailAddressTextField.layer.borderColor = doMatch ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmEmailAddressLabel.text = doMatch ? "Email addresses match." : "Email addresses do not match."
        confirmEmailAddressLabel.textColor = doMatch ? nil : .red
    }
    
    func validatePassword(isValid: Bool, passwordTextField: UITextField, passwordLabel: UILabel) {
        
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        passwordLabel.text = isValid ? "Please enter a valid password." : "Please enter a valid password. Minimum length 8 characters including at least one uppercase, one number, and one special character."
        passwordLabel.textColor = isValid ? nil : .red

    }
}
