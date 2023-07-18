//
//  EditEmployeeAccountDetailsViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountDetailsViewController: UIViewController{

    private var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var employeeAccountTypeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    

    private var tableView = UITableView()
    private let userAccountTypeDropDownMenu = UserAccountTypeDropDownMenu()
    
    var userAccount: Employee?
    var userAccountSet: Set<Employee>?
    private let accountTypeDropDownMenu = UserAccountTypeDropDownMenu()
    private let accountTypes: [AccountTypes] = AccountTypes.allCases
    private var accountType: AccountTypes?
    private let textFieldStyle = TextFieldStyle()
    private var textFields: [UITextField] = []
    
    private var isNameValid = false
    private var isLastNameValid = false
    private var isEmailValid = false
    private var doEmailsMatch = false
    private var isPasswordValid = false
    private var doPasswordsMatch = false
    private var isFailWithError: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserAccountTypeCell.self, forCellReuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.userAccountTypeCellIdentifier)
        setupTextFields()
        addUserCurrentInfoUpdateView()
        setupTapGesture()
        enableSaveChangesButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
        tableView.removeFromSuperview()
        
       }
    
    private func setupTapGesture() {
           tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
           tapGesture?.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture!)
       }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
            // Dismiss the dropdown menu
        tableView.removeFromSuperview()

            // Dismiss the keyboard
            view.endEditing(true)

        }
    
    private func setupTextFields() {
        textFields = [nameTextField, lastNameTextField,emailTextField, emailConfirmTextField, passwordTextField, passwordConfirmTextField]
        
        for textField in textFields {
            textField.delegate = self
            textFieldStyle.styleTextField(textField)
        }
    }
    
    private func addUserCurrentInfoUpdateView() {
       
        guard let userSafe = userAccount else {return}
        let emailAddress = userSafe.emailAddress
        let firstName = userSafe.userFirstName
        let password = userSafe.password
        let lastName = userSafe.userLastName
        
        if let name = nameTextField,
        let email = emailTextField,
        let pass = passwordTextField,
            let surname = lastNameTextField {
            name.text = firstName
            email.text = emailAddress
            pass.text = password
            surname.text = lastName
        }
        
        employeeAccountTypeButton.setTitle(userSafe.accountType.rawValue, for: .normal)
    }
    
    @IBAction func discardButton(_ sender: UIButton) {
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
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .fullScreen
        present(loadingViewController, animated: false)
        
        loadingViewController.dismiss(animated: false) {
            self.editUserAccountChanges { isEdited in
                switch isEdited {
                case .success:
                    self.performSegue(withIdentifier: Constant.Segue.Admin.editUserAccountToSuccess, sender: self)
                case .failure(let error):
                    self.isFailWithError = error
                    self.performSegue(withIdentifier: Constant.Segue.Admin.editUserAccountToFail, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Admin.editUserAccountToFail {
            if let editFailVC = segue.destination as? EditUserAccountFailViewController {
                editFailVC.failMessage = isFailWithError
            }
        }
    }
    
    @IBAction func accountTypeButton(_ sender: UIButton) {
        showDropDownMenu()
    }
    
    private func enableSaveChangesButton() {
        saveChangesButton.isEnabled = isNameValid && isLastNameValid && isPasswordValid && doPasswordsMatch && isEmailValid && doEmailsMatch
    }
    
    private func showDropDownMenu() {
        userAccountTypeDropDownMenu.showDropdownMenu(from: employeeAccountTypeButton, with: accountTypes, tableView: tableView) { [weak self] selectedAccountType in
            self?.accountType = selectedAccountType
            self?.employeeAccountTypeButton.setTitle(selectedAccountType.rawValue, for: .normal)
            self?.enableSaveChangesButton()
        }
    }
    
}

extension EditUserAccountDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {return true}
        let userAccountValidator = UserAccountValidator()
        switch textField {
        case nameTextField:
            isNameValid = userAccountValidator.validateName(updatedText, employeeNameTextField: nameTextField, employeeNameLabel: nameLabel)
        case lastNameTextField:
            isLastNameValid = userAccountValidator.validateSurname(updatedText, employeeSurnameTextField: lastNameTextField, employeeSurnameLabel: lastNameLabel)
        case emailTextField:
            isEmailValid = userAccountValidator.validateEmail(updatedText, emailAddressTextField: emailTextField, emailAddressLabel: emailLabel)
            doEmailsMatch = userAccountValidator.doEmailsMatch(updatedText, emailConfirmTextField.text ?? "", confirmEmailAddressTextField: emailConfirmTextField, confirmEmailAddressLabel: confirmEmailLabel)
        case emailConfirmTextField:
            doEmailsMatch = userAccountValidator.doEmailsMatch(emailTextField.text ?? "", updatedText, confirmEmailAddressTextField: emailConfirmTextField, confirmEmailAddressLabel: confirmEmailLabel)
        case passwordTextField:
            isPasswordValid = userAccountValidator.validatePassword(updatedText, passwordTextField: passwordTextField, passwordLabel: passwordLabel)
            doPasswordsMatch = userAccountValidator.doPasswordsMatch(updatedText, passwordConfirmTextField.text ?? "", confirmPasswordTextField: passwordConfirmTextField, confirmPasswordLabel: confirmPasswordLabel)
        case passwordConfirmTextField:
            doPasswordsMatch = userAccountValidator.doPasswordsMatch(passwordTextField.text ?? "", updatedText, confirmPasswordTextField: passwordConfirmTextField, confirmPasswordLabel: confirmPasswordLabel)
        default:
            break
        }
        enableSaveChangesButton()
        return true
    }
    
}

extension EditUserAccountDetailsViewController {
    private func editUserAccountChanges(completion: @escaping(EditAccountResult) -> Void) {
        guard let name = nameTextField.text,
                  let lastName = lastNameTextField.text,
                  let email = emailTextField.text,
                  let password = passwordTextField.text else {
                completion(.failure(message: "Missing required fields."))
                return
            }
            
            let search = Search<Employee>()
            
            if let userAccountSet = userAccountSet, let userAccount = userAccount {
                let userAccounts = Array(userAccountSet)
                let sortedUserAccounts = userAccounts.sorted()
                
                if search.binarySearch(sortedUserAccounts, target: email, keyPath: \.emailAddress) != nil && userAccount.emailAddress != email {
                    completion(.failure(message: "\(email) email address exists. Please try another email address."))
                    return
                }
            }
            
            userAccount?.changeName(newName: name)
            userAccount?.changeLastName(newLastName: lastName)
            userAccount?.changeEmail(newEmail: email)
            userAccount?.changePassword(newPassword: password)
            if let accountType = accountType {
                userAccount?.changeAccountType(newAccountType: accountType)
            }
                
            
            completion(.success)
    }
    
   
}

extension EditUserAccountDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.DropDownMenu.userAccountTypeCellIdentifier) as? UserAccountTypeCell ?? UserAccountTypeCell(style: .default, reuseIdentifier: Constant.TableCellIdentifier.DropDownMenu.userAccountTypeCellIdentifier)
            
        cell.textLabel?.text = accountTypes[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountTypes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAccount = accountTypes[indexPath.row]
        self.accountType = selectedAccount
        employeeAccountTypeButton.setTitle(selectedAccount.rawValue, for: .normal)
        tableView.removeFromSuperview()
        enableSaveChangesButton()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
