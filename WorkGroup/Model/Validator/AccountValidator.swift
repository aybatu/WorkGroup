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
        let textFieldLabelView = TextFieldAccountValidatorView()
        let doMatch = password == confirmPassword
        
        textFieldLabelView.doPasswordsMatch(doMatch: doMatch, confirmPasswordTextField: confirmPasswordTextField, confirmPasswordLabel: confirmPasswordLabel)
        
        return doMatch
    }
    
    func validateName(_ name: String, employeeNameTextField: UITextField, employeeNameLabel: UILabel ) -> Bool {
        let textFieldLabelView = TextFieldAccountValidatorView()
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !trimmedName.isEmpty
        
        textFieldLabelView.validateName(isValid: isValid, employeeNameTextField: employeeNameTextField, employeeNameLabel: employeeNameLabel)
        
        return isValid
    }
    
    func validateSurname(_ surname: String, employeeSurnameTextField: UITextField, employeeSurnameLabel: UILabel) -> Bool {
        let textFieldLabelView = TextFieldAccountValidatorView()
        let trimmedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !trimmedSurname.isEmpty
        
        textFieldLabelView.validateSurname(isValid: isValid, employeeSurnameTextField: employeeSurnameTextField, employeeSurnameLabel: employeeSurnameLabel)
        
        return isValid
    }
    
    func validateEmail(_ email: String, emailAddressTextField: UITextField, emailAddressLabel: UILabel) -> Bool {
        let textFieldLabelView = TextFieldAccountValidatorView()
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: email)
        
        textFieldLabelView.validateEmail(isValid: isValid, emailAddressTextField: emailAddressTextField, emailAddressLabel: emailAddressLabel)
        
        return isValid
    }
    
    func doEmailsMatch(_ email: String, _ confirmEmail: String, confirmEmailAddressTextField: UITextField, confirmEmailAddressLabel: UILabel) -> Bool {
        let textFieldLabelView = TextFieldAccountValidatorView()
        let doMatch = email == confirmEmail
        
        textFieldLabelView.doEmailsMatch(doMatch: doMatch, confirmEmailAddressTextField: confirmEmailAddressTextField, confirmEmailAddressLabel: confirmEmailAddressLabel)
        
        return doMatch
    }
    
    func validatePassword(_ password: String, passwordTextField: UITextField, passwordLabel: UILabel) -> Bool {
        let textFieldLabelView = TextFieldAccountValidatorView()
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValid = passwordPredicate.evaluate(with: password)
        
        textFieldLabelView.validatePassword(isValid: isValid, passwordTextField: passwordTextField, passwordLabel: passwordLabel)
        
         return isValid
    }
}
