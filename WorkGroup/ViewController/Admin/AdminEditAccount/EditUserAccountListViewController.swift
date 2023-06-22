//
//  EditAccountEmployeeListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class EditUserAccountListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var employeeListTableView: UITableView!
    
    let emailList: [String] = ["employee1@company.com", "employee2@company.com", "employee3@company.com", "manager1@company.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Admin.editEmployeeAccountListCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = emailList[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Admin.accountListToAccountEdit, sender: self)
        
        
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

