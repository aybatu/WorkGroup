//
//  MeetingEditEmployeeListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditEmployeeListViewController: UIViewController {

    @IBOutlet weak var invitedEmployeeListTableView: UITableView!
    private let isSave = true
    private let employeeList = ["Employee1", "Employee2", "Employee3", "Employee4", "Employee5", "Employee6", "Employee7", "Employee8","Employee9", "Employee10", "Employee11", "Employee12"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Meeting Employee List"
        invitedEmployeeListTableView.delegate = self
        invitedEmployeeListTableView.dataSource = self
        invitedEmployeeListTableView.allowsMultipleSelection = true
    }
    

  
     @IBAction func saveChangesButton(_ sender: UIButton) {
         
         isSave ? performSegue(withIdentifier: Constant.Segue.Manager.editInvitedEmployeeToSuccess, sender: self) :
             performSegue(withIdentifier: Constant.Segue.Manager.editInvitedEmployeeToFail, sender: self)
 
     }
     
    @IBAction func discardButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard?", preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
            self.performDiscard()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func performDiscard() {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    
}

extension MeetingEditEmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = invitedEmployeeListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.editMeetingEmployeeListCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = employeeList[indexPath.row]
        
        let isSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false
        
        cell.accessoryType = isSelected ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
    }
}
