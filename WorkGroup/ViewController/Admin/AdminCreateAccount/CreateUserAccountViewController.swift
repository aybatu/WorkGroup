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
    
    var userAccounts: Set<UserAccount> = []
    private var isAccountCreated = true
    private var tableView = UITableView()
    private var textFields: [UITextField] = []
    private var isNameValid = false
    private var isSurnameValid = false
    private var isEmailValid = false
    private var doEmailsMatch = false
    private var isPasswordValid = false
    private var doPasswordsMatch = false
    private var isAccountExist = false
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
            let loadingViewController = LoadingViewController()
            let newUser = UserAccount(accountType: accountType, emailAddress: emailAddress, userFirstName: employeeName, userLastName: employeeSurname, password: password)
            let search = Search<RegisteredCompany>()
            let companies = TemporaryDatabase.registeredCompanies
            loadingViewController.modalPresentationStyle = .fullScreen
            present(loadingViewController, animated: false)
            
            
            loadingViewController.dismiss(animated: false) {
                if let company = search.binarySearch(companies, target: registerNo, keyPath: \.registrationNumber) {
                    let (inserted, _) = self.userAccounts.insert(newUser)
                    if inserted {
                        company.addUserAccount(newUser)
                        self.isAccountCreated = true
                        self.isAccountExist = false
                    } else {
                        self.isAccountCreated = false
                        self.isAccountExist = true
                    }
                }
                
                if self.isAccountCreated {
                    self.performSegue(withIdentifier: Constant.Segue.Admin.createAccountToSuccess, sender: self)
                } else {
                    self.performSegue(withIdentifier: Constant.Segue.Admin.createAccountToFail, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Admin.createAccountToFail {
            if let failVC = segue.destination as? CreateUserAccountFailViewController {
                failVC.errorMessage = (emailAddressTextField.text ?? "") + " " + Constant.Warning.CreateAccount.isAccountExist
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

extension CreateUserAccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {return true}
      
        let userAccountValidator = UserAccountValidator()
        switch textField {
        case employeeNameTextField:
            isNameValid = userAccountValidator.validateName(updatedText, employeeNameTextField: employeeNameTextField, employeeNameLabel: employeeNameLabel)
        case employeeSurnameTextField:
            isSurnameValid = userAccountValidator.validateSurname(updatedText, employeeSurnameTextField: employeeSurnameTextField, employeeSurnameLabel: employeeSurnameLabel)
        case emailAddressTextField:
            isEmailValid = userAccountValidator.validateEmail(updatedText, emailAddressTextField: emailAddressTextField, emailAddressLabel: emailAddressLabel)
        case confirmEmailAddressTextField:
            doEmailsMatch = userAccountValidator.doEmailsMatch(emailAddressTextField?.text ?? "", updatedText, confirmEmailAddressTextField: confirmEmailAddressTextField, confirmEmailAddressLabel: confirmEmailAddressLabel)
        case passwordTextField:
            isPasswordValid = userAccountValidator.validatePassword(updatedText, passwordTextField: passwordTextField, passwordLabel: passwordLabel)
        case confirmPasswordTextField:
            doPasswordsMatch = userAccountValidator.doPasswordsMatch(passwordTextField?.text ?? "", updatedText, confirmPasswordTextField: confirmPasswordTextField, confirmPasswordLabel: confirmPasswordLabel)
        default:
            break
        }
        enableRegistrationButton()
        
        return true
                
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
