//
//  EmployeeMeetingListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeMeetingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var meetingListTableView: UITableView!
    
    let meetingList = ["Meeting1", "Meeting2", "Meeting3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meetingListTableView.delegate = self
        meetingListTableView.dataSource = self
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func mainMenu(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meetingListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Employee.employeeMeetingListCellIdentifier, for: indexPath)
        cell.textLabel?.text = meetingList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.Employee.meetingListToMeetingDetails, sender: self)
    }
    
}
