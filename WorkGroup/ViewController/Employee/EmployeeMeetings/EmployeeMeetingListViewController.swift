//
//  EmployeeMeetingListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeMeetingListViewController: UIViewController {
    
    @IBOutlet weak var meetingListTableView: UITableView!
    var employee: UserAccount?
    private var meetingList: [Meeting] = []
    private var selectedMeeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        meetingListTableView.delegate = self
        meetingListTableView.dataSource = self
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Employee.Meeting.meetingListToMeetingDetails {
            if let meetingDetailsVC = segue.destination as? EmployeeMeetingDetailsViewController {
                meetingDetailsVC.meeting = selectedMeeting
            }
        }
    }
    private func loadData() {
        if let employeeSafe = employee {
            meetingList = employeeSafe.employeeMeetings
        }
    }
        
}

extension EmployeeMeetingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meetingListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Employee.employeeMeetingListCellIdentifier, for: indexPath)
        cell.textLabel?.text = meetingList[indexPath.row].meetingTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeeting = meetingList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Employee.Meeting.meetingListToMeetingDetails, sender: self)
    }
}
