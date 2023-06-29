//
//  TextFieldCompanyValidatorView.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 27/06/2023.
//

import UIKit

class TextFieldCompanyValidatorView {
    func checkForCompanyName(isEmpty: Bool, companyNameTextField: UITextField, companyNameLabel: UILabel) {
       
        companyNameLabel.text = isEmpty ? "Company name is required." : "Company name."
        companyNameLabel.textColor = isEmpty ? .red : nil
        companyNameTextField.layer.borderWidth = 1.0
        companyNameTextField.layer.borderColor = isEmpty ? UIColor.red.cgColor : UIColor.green.cgColor
 
    }
}
