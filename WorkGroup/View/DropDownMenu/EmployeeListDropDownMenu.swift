//
//  EmployeeListDropDownMenu.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 28/06/2023.
//

import UIKit

class EmployeeListDropDownMenu {
    private var tableView = UITableView()
    private var userAccounts: [UserAccount] = []
    
    func showDropdownMenu(from button: UIButton, with userAccounts: [UserAccount], tableView: UITableView, completion: @escaping (UserAccount) -> Void) {
        self.tableView = tableView
        guard button.superview is UIStackView else { return }
        guard let buttonStackViewFrame = button.superview as? UIStackView else { return }
        let dropDownFrame = buttonStackViewFrame.convert(button.frame, to: button.window)
        
        tableView.frame = CGRect(x: dropDownFrame.minX, y: dropDownFrame.maxY, width: dropDownFrame.width, height: 0)
        button.window?.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        tableView.separatorStyle = .none
        
        self.userAccounts = userAccounts
        
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            let menuHeight = CGFloat(4 * 42)
            let buttonBottomY = dropDownFrame.maxY
            self.tableView.frame = CGRect(x: dropDownFrame.minX, y: buttonBottomY, width: dropDownFrame.width, height: menuHeight)
        }
    }
    

}
