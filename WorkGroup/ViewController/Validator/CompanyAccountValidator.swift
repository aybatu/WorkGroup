//
//  CompanyRegistrationValidator.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 25/06/2023.
//

import UIKit

class CompanyAccountValidator: AccountValidator {
    func checkForCompanyName(_ text: String, companyNameTextField: UITextField, companyNameLabel: UILabel) -> Bool {
        let isEmpty = text.isEmpty
        companyNameLabel.text = isEmpty ? "Company name is required." : "Company name."
        companyNameLabel.textColor = isEmpty ? .red : nil
        companyNameTextField.layer.borderWidth = 1.0
        companyNameTextField.layer.borderColor = isEmpty ? UIColor.red.cgColor : UIColor.green.cgColor
        return !isEmpty
    }
    
}
