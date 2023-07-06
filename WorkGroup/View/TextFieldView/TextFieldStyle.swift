//
//  TextFieldStyle.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 05/07/2023.
//

import UIKit

struct TextFieldStyle {
    func styleTextField(_ textField: UITextField) {
        // Set background color
        textField.backgroundColor = UIColor.white
        
        // Set corner radius
        textField.layer.cornerRadius = 8.0
        
        
        // Add border
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        // Set font and text color
        textField.textColor = UIColor.black
        
        // Set placeholder color
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Set keyboard appearance
        textField.keyboardAppearance = .light
    }
}
