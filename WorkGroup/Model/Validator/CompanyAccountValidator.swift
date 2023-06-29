//
//  CompanyRegistrationValidator.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 25/06/2023.
//

import UIKit

class CompanyAccountValidator: AccountValidator {
    func checkForCompanyName(_ text: String, companyNameTextField: UITextField, companyNameLabel: UILabel) -> Bool {
        let textFieldCompanyView = TextFieldCompanyValidatorView()
        let isEmpty = text.isEmpty
        textFieldCompanyView.checkForCompanyName(isEmpty: isEmpty, companyNameTextField: companyNameTextField, companyNameLabel: companyNameLabel)
        return !isEmpty
    }
    
}
