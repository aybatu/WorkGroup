//
//  EmployeeMeetingListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeMeetingListViewController: UIViewController {
    
    @IBOutlet weak var meetingListTableView: UITableView!
    var employee: Employee?
    private var meetingList: [Meeting] = []
    private var selectedMeeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        meetingListTableView.register(UINib(nibName: Constant.CustomCell.meetingListCellNib, bundle: nil), forCellReuseIdentifier: Constant.CustomCell.meetingListCellIdentifier)
        meetingListTableView.delegate = self
        meetingListTableView.dataSource = self
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
   
    
  
    private func loadData() {
        if let employeeSafe = employee {
            meetingList = employeeSafe.employeeInvitedMeetings
        }
    }
        
}

extension EmployeeMeetingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = meetingListTableView.dequeueReusableCell(withIdentifier: Constant.CustomCell.meetingListCellIdentifier, for: indexPath) as! MeetingListTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        
        cell.meetingTitleLabel.text = meetingList[indexPath.row].meetingTitle
        cell.meetingDescriptionLabel.text = meetingList[indexPath.row].meetingDescription
        cell.meetingDateLabel.text = "Date: \(dateFormatter.string(from: meetingList[indexPath.row].meetingDate))"
        cell.meetingStartTimeLabel.text = "Start Time: \(timeFormatter.string(from: meetingList[indexPath.row].meetingStartTime))"
        cell.meetingEndTimeLabel.text = "End Time: \(timeFormatter.string(from: meetingList[indexPath.row].meetingEndTime))"
        cell.meetingTimeProgressBar.progress = progressBarCalculator(date: meetingList[indexPath.row].meetingDate, startTime: meetingList[indexPath.row].meetingStartTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeeting = meetingList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    private func progressBarCalculator(date: Date, startTime: Date) -> Float {
        // Get the current date and time
        let calendar = Calendar.current
       
        let dateComponenets = calendar.dateComponents([.day, .month, .year], from: date)
        let timeCompnenets = calendar.dateComponents([.hour, .minute], from: startTime)
        
        var mergedDateComponenets = DateComponents()
        mergedDateComponenets.year = dateComponenets.year
        mergedDateComponenets.month = dateComponenets.month
        mergedDateComponenets.day = dateComponenets.day
        mergedDateComponenets.hour = timeCompnenets.hour
        mergedDateComponenets.minute = timeCompnenets.minute
        
        let mergedDate = calendar.date(from: mergedDateComponenets) ?? date
        // Calculate the time interval between the current date and the merged date
         let timeInterval = mergedDate.timeIntervalSince(Date())
         
         // Calculate the total duration of the meeting in seconds (e.g., one month from the start date)
         let totalDuration: TimeInterval = 30 * 24 * 60 * 60 // Assuming one month duration (30 days)
         
         // Calculate the progress as a percentage
         let progress = Float(1) - Float(max(0, min(timeInterval, totalDuration))) / Float(totalDuration)
         
         return max(0, min(progress, 1))
    }
}
