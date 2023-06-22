//
//  CreateAccountViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class CellClass: UITableViewCell {
    // Custom cell class
}

class CreateUserAccountViewController: UIViewController {
    @IBOutlet private weak var employeeNameTextField: UITextField!
    @IBOutlet private weak var employeeNameLabel: UILabel!
    @IBOutlet private weak var employeeSurnameLabel: UILabel!
    @IBOutlet private weak var employeeSurnameTextField: UITextField!
    @IBOutlet private weak var selectAccountTypeButton: UIButton!
    @IBOutlet private weak var emailAddressTextField: UITextField!
    @IBOutlet private weak var emailAddressLabel: UILabel!
    @IBOutlet private weak var confirmEmailAddressTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var confirmPasswordLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var createUserAccButton: UIButton!
    @IBOutlet private weak var confirmEmailAddressLabel: UILabel!
    
    private var isAccountCreated = true
    private var tableView = UITableView()
    private var textFields: [UITextField] = []
    private var isNameValid = false
    private var isSurnameValid = false
    private var isEmailValid = false
    private var doEmailsMatch = false
    private var isPasswordValid = false
    private var doPasswordsMatch = false
    var companyRegistrationNo: String?
    private var accountTypes: [AccountTypes] = AccountTypes.allCases
    private var accountType: AccountTypes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserAccButton.isEnabled = false
        setupTextFields()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        
    }
    
    private func setAccountTypes() {
        accountTypes.append(contentsOf: AccountTypes.allCases)
    }
    
    private func setupTextFields() {
        textFields = [employeeNameTextField, employeeSurnameTextField, emailAddressTextField, confirmEmailAddressTextField, passwordTextField, confirmPasswordTextField]
        textFields.forEach { $0.delegate = self }
    }
    
    @IBAction private func createUserAccButtonTapped(_ sender: UIButton) {
        guard let employeeName = employeeNameTextField.text,
              let employeeSurname = employeeSurnameTextField.text,
              let emailAddress = emailAddressTextField.text,
              let password = passwordTextField.text,
              let accountType = accountType,
              let registerNo = companyRegistrationNo else {
            return
        }
        
        if isEmailValid && doEmailsMatch && isPasswordValid && doPasswordsMatch && isNameValid && isSurnameValid {
            
            let newUser = UserAccount(accountType: accountType, emailAddress: emailAddress, userFirstName: employeeName, userLastName: employeeSurname, password: password)
            let search = Search<RegisteredCompany>()
            let companies = TemporaryDatabase.registeredCompanies
            if let company = search.binarySearch(companies, target: registerNo, keyPath: \.registrationNumber) {
                company.addUserAccount(newUser)
                isAccountCreated = true
            }
            
            if isAccountCreated {
                performSegue(withIdentifier: Constant.Segue.Admin.createAccountToSuccess, sender: self)
            } else {
                performSegue(withIdentifier: Constant.Segue.Admin.createAccountToFail, sender: self)
            }
        }
    }
    
    @IBAction private func selectAccountTypeMenu(_ sender: UIButton) {
        showDropdownMenu()
    }
    
    private func showDropdownMenu() {
        guard selectAccountTypeButton.superview is UIStackView else {return}
        guard let buttonStackViewFrame = selectAccountTypeButton.superview as? UIStackView else { return }
        let dropDownFrame = buttonStackViewFrame.convert(selectAccountTypeButton.frame, to: view)
        tableView.frame = CGRect(x: dropDownFrame.minX, y: dropDownFrame.maxY, width: dropDownFrame.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            let menuHeight = CGFloat(self.accountTypes.count * 42)
            let buttonBottomY = dropDownFrame.maxY
            self.tableView.frame = CGRect(x: dropDownFrame.minX, y: buttonBottomY, width: dropDownFrame.width, height: menuHeight)
        }
        
    }
    
    @IBAction private func discardButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard?", preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
            self.performDiscard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func performDiscard() {
        guard let navigationController = self.navigationController else { return }
        
        textFields.forEach { $0.text = "" }
        
        navigationController.popViewController(animated: true)
    }
    
    private func enableRegistrationButton() {
        createUserAccButton.isEnabled = isEmailValid && doEmailsMatch && isPasswordValid && doPasswordsMatch && isNameValid && isSurnameValid && accountType != nil
    }
}

extension CreateUserAccountViewController {
    private func validateName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !trimmedName.isEmpty
        
        employeeNameTextField.layer.borderWidth = 1.0
        employeeNameTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        employeeNameLabel.text = isValid ? "Employee Name" : "Employee Name is required"
        employeeNameLabel.textColor = isValid ? nil : .red
        
        isNameValid = isValid
    }
    
    private func validateSurname(_ surname: String) {
        let trimmedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !trimmedSurname.isEmpty
        
        employeeSurnameTextField.layer.borderWidth = 1.0
        employeeSurnameTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        employeeSurnameLabel.text = isValid ? "Employee Surname" : "Employee Surname is required"
        employeeSurnameLabel.textColor = isValid ? nil : .red
        
        isSurnameValid = isValid
    }
    
    private func validateEmail(_ email: String) {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: email)
        
        emailAddressTextField.layer.borderWidth = 1.0
        emailAddressTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        emailAddressLabel.text = isValid ? "Please enter a valid email address." : "Please enter a valid password. Minimum length 8 characters including at least one uppercase, one number, and one special character."
        emailAddressLabel.textColor = isValid ? nil : .red
        
        isEmailValid = isValid
    }
    
    private func doEmailsMatch(_ email: String, _ confirmEmail: String) {
        let doMatch = email == confirmEmail
        
        confirmEmailAddressTextField.layer.borderWidth = 1.0
        confirmEmailAddressTextField.layer.borderColor = doMatch ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmEmailAddressLabel.text = doMatch ? "Email addresses match." : "Email addresses do not match."
        confirmEmailAddressLabel.textColor = doMatch ? nil : .red
        
        doEmailsMatch = doMatch
    }
    
    private func validatePassword(_ password: String) {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValid = passwordPredicate.evaluate(with: password)
        
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        passwordLabel.text = isValid ? "Please enter a valid password." : "Please enter a valid password. Minimum length 8 characters including at least one uppercase, one number, and one special character."
        passwordLabel.textColor = isValid ? nil : .red
        
        isPasswordValid = isValid
    }
    
    private func doPasswordsMatch(_ password: String, _ confirmPassword: String) {
        let doMatch = password == confirmPassword
        
        confirmPasswordTextField.layer.borderWidth = 1.0
        confirmPasswordTextField.layer.borderColor = doMatch ? UIColor.green.cgColor : UIColor.red.cgColor
        confirmPasswordLabel.text = doMatch ? "Passwords match." : "Passwords do not match."
        confirmPasswordLabel.textColor = doMatch ? nil : .red
        
        doPasswordsMatch = doMatch
    }
}

extension CreateUserAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case employeeNameTextField:
            validateName(employeeNameTextField?.text ?? "")
        case employeeSurnameTextField:
            validateSurname(employeeSurnameTextField?.text ?? "")
        case emailAddressTextField:
            validateEmail(emailAddressTextField?.text ?? "")
        case confirmEmailAddressTextField:
            doEmailsMatch(emailAddressTextField?.text ?? "", confirmEmailAddressTextField?.text ?? "")
        case passwordTextField:
            validatePassword(passwordTextField?.text ?? "")
        case confirmPasswordTextField:
            doPasswordsMatch(passwordTextField?.text ?? "", confirmPasswordTextField?.text ?? "")
        default:
            break
        }
        enableRegistrationButton()
    }
}

extension CreateUserAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = accountTypes[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountTypes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accountType = accountTypes[indexPath.row]
        selectAccountTypeButton.setTitle(accountType?.rawValue, for: .normal)
        tableView.removeFromSuperview()
        enableRegistrationButton()
    }
    
}
