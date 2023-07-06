//
//  MeetingEditListEViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditListEViewController: UIViewController {

    @IBOutlet weak var editMeetingListTableView: UITableView!
    let meetingList = ["Meeting1", "Meeting2", "Meeting3"]
    override func viewDidLoad() {
        super.viewDidLoad()

        editMeetingListTableView.delegate = self
        editMeetingListTableView.dataSource = self
    }
    

    @IBAction func mainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}

extension MeetingEditListEViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editMeetingListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.editMeetingListCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = meetingList[indexPath.row]
        
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: Constant.Segue.Manager.editMeetingListToMeetingDetails, sender: self)
    }
    
    
}
