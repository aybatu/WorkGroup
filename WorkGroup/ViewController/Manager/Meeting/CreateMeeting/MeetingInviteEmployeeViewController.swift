//
//  MeetingInviteEmployeeViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingInviteEmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var employeeListTableView: UITableView!
    
    @IBOutlet weak var employeeSearchBar: UISearchBar!
    let employeeList: [String] = ["Employee1", "Employee2", "Employee3", "Employee4", "Employee5", "Employee6", "Employee7", "Employee8","Employee9", "Employee10", "Employee11", "Employee12"]

    let isMeetingRequestSend = true
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeListTableView.allowsMultipleSelection = true
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
        
        navigationItem.title = "Employee List"
    }
    
    @IBAction func sendMeetingInviteButton(_ sender: UIButton) {
        if isMeetingRequestSend {
            performSegue(withIdentifier: Constant.Segue.Manager.sendMeetingRequestTotSuccess, sender: self)
        } else {
            performSegue(withIdentifier: Constant.Segue.Manager.sendMeetingRequestToFail, sender: self)
        }
    }
    
    @IBAction func discardButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard?", preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
            self.performDiscard()
        }
        let cancelAction = UIAlertAction(title: "Cancerl", style: .cancel)
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func performDiscard() {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
  
    
}
extension MeetingInviteEmployeeViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = employeeListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.meetingEmployeListCellIdentifier, for: indexPath)
       
        cell.textLabel?.text = employeeList[indexPath.row]
        
        // Determine if the current row is selected
        let isSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false
        
        // Set the accessory type based on the selected state
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
