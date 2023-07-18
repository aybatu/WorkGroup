//
//  MeetingEditListEViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditListViewController: UIViewController {

    @IBOutlet weak var editMeetingListTableView: UITableView!
    var meetingList: [Meeting] = []
    var company: Company?
    private var selectedMeeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMeetingList()
        setupTableView()
    }
    
    private func setupMeetingList() {
        if let companySafe = company {
            meetingList = Array(companySafe.meetings)
        }
    }
    private func setupTableView() {
        editMeetingListTableView.delegate = self
        editMeetingListTableView.dataSource = self
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}

extension MeetingEditListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editMeetingListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.editMeetingListCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = meetingList[indexPath.row].meetingTitle
        
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeeting = meetingList[indexPath.row]
        performSegue(withIdentifier: Constant.Segue.Manager.Meeting.EditMeeting.editMeetingListToMeetingDetails, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Meeting.EditMeeting.editMeetingListToMeetingDetails {
            if let meetingDetailsVC = segue.destination as? MeetingEditDetailsViewController {
                meetingDetailsVC.company = company
                meetingDetailsVC.meeting = selectedMeeting
            }
        }
    }
    
}
