//
//  EditAccountEmployeeListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountListViewController: UIViewController {
    
    @IBOutlet weak var employeeListTableView: UITableView!
    
    var userAccounts: Set<UserAccount> = []
    var registrationNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeListTableView.allowsSelection = true
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
        employeeListTableView.register(UINib(nibName: Constant.TableCellIdentifier.Admin.editUserListCellNib, bundle: nil), forCellReuseIdentifier: Constant.TableCellIdentifier.Admin.editUserListCellIdentifier)
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension EditUserAccountListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Admin.editUserListCellIdentifier, for: indexPath) as! EmployeeListTableCell
           
           let userAccountArray = Array(userAccounts)
           if indexPath.row < userAccountArray.count {
               let userAccount = userAccountArray[indexPath.row]
               cell.employeeNameLabel.text = "Name: " + userAccount.userFirstName + " " + userAccount.userLastName
               cell.employeeEmailAddressLabel.text = "Email: " + userAccount.emailAddress
               cell.employeeAccountTypeLabel.text = "Permission: " + userAccount.accountType.rawValue
           }
           
           return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constant.Segue.Admin.accountListToAccountEdit, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Admin.accountListToAccountEdit {
               if let editUserAccountDetailsVC = segue.destination as? EditUserAccountDetailsViewController {
                   if let selectedIndexPath = employeeListTableView.indexPathForSelectedRow {
                       
                       let userAccountArray = Array(userAccounts)
                       if selectedIndexPath.row < userAccountArray.count {
                           let selectedUserAccount = userAccountArray[selectedIndexPath.row]
                          
                           editUserAccountDetailsVC.userAccount = selectedUserAccount
                           editUserAccountDetailsVC.userAccountSet = userAccounts
                       }
                   }
               }
           }
       }
}
