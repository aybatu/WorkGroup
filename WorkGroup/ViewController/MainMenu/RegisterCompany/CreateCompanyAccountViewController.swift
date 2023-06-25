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
    
    private var registeredCompany: RegisteredCompany?
    private var isErrorWithMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCompanyButton.isEnabled = false
        setupTextFields()

        textFields = [companyNameTextField, firstNameTextField, surnameTextField, emailAddressTextField, emailAddressConfirmTextField, passwordTextField, confirmPasswordTextField]
        
        navigationController?.title = "COMPANY REGISTRATION"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    @IBAction func registerCompanyButton(_ sender: UIButton) {
        
        createUserAccount { result in
            switch result {
            case .success:
                self.performSegue(withIdentifier: Constant.Segue.RegisterCompany.createAccountToSuccess, sender: self)
            case .failure(let errorMessage):
                self.isErrorWithMessage = errorMessage
                self.performSegue(withIdentifier: Constant.Segue.RegisterCompany.createAccountToFail, sender: self)
                
                
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
                if let errorMessageSafe = isErrorWithMessage {
                    createAccountFailVC.errorMessage = errorMessageSafe
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
        case emailAddressConfirmTextField:
            isEmailMatch = companyAccountValidator.doEmailsMatch(emailAddressTextField.text ?? "", updatedText, confirmEmailAddressTextField: emailAddressConfirmTextField, confirmEmailAddressLabel: confirmEmailAddressLabel)
        case passwordTextField:
            isPasswordValid = companyAccountValidator.validatePassword(updatedText, passwordTextField: passwordTextField, passwordLabel: passwordLabel)
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
    func createUserAccount(completion: @escaping(AccountCreationResult) ->Void) {
        guard let emailAddress = emailAddressTextField.text,
              let companyName = companyNameTextField.text,
              let password = passwordTextField.text,
              let firstName = firstNameTextField.text,
              let surname = surnameTextField.text else {
            completion(.failure(message: "Missing required fields."))
            return
        }
        
        let search = Search<RegisteredCompany>()
        let registeredCompanies = TemporaryDatabase.registeredCompanies
        let sortedCompanyByEmailOfOwner = registeredCompanies.sorted(by: {$0.ownerAccount.emailAddress < $1.ownerAccount.emailAddress})
        
        if let _ = search.binarySearch(sortedCompanyByEmailOfOwner, target: emailAddress, keyPath: \.ownerAccount.emailAddress) {
            completion(.failure(message: "An account with this email address already exists."))
            return
        }
        
        let createdOwnerAccount = UserAccount(accountType: .ADMIN, emailAddress: emailAddress, userFirstName: firstName, userLastName: surname, password: password)
        self.registeredCompany = RegisteredCompany(companyName: companyName, ownerAccount: createdOwnerAccount)
        self.registeredCompany?.addUserAccount(createdOwnerAccount)
        TemporaryDatabase.registeredCompanies.append(registeredCompany!)
        
        
        completion(.success)
        
    }
    
    
}
