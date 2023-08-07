//
//  MeetingEditDetailsViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditDetailsViewController: UIViewController {
    
    @IBOutlet weak var meetingTitleTextField: UITextField!
    
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    
    @IBOutlet weak var meetingStartTimePicker: UIDatePicker!
    @IBOutlet weak var meetingEndTimePicker: UIDatePicker!
    
    @IBOutlet weak var meetingDatePicker: UIDatePicker!
    
    var company: Company?
    var meeting: Meeting?
    
    private var isSave = true
    private let styleTextView = TextView()
    private let styleTextField = TextFieldStyle()
    
    private var meetingDetails: [String: Any?] = [
        Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetingDate: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: nil
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextArea()
        setupMeetingDetails()
        setupMeetingDate()
        navigationItem.title = "MEETING DETAILS"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    private func styleTextArea() {
        styleTextView.styleTextView(meetingDescriptionTextView)
        styleTextField.styleTextField(meetingTitleTextField)
    }
    private func setupMeetingDetails() {
        if let meetingSafe = meeting{
            meetingDetails = [
                Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: meetingSafe.meetingTitle,
                Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: meetingSafe.meetingDescription,
                Constant.Dictionary.MeetingDetailsDictionary.meetingDate: meetingSafe.meetingDate,
                Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: meetingSafe.meetingStartTime,
                Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: meetingSafe.meetingEndTime
              ]
            meetingDatePicker.date = meetingSafe.meetingDate
            meetingStartTimePicker.date = meetingSafe.meetingStartTime
            meetingEndTimePicker.date = meetingSafe.meetingEndTime
            meetingTitleTextField.text = meetingSafe.meetingTitle
            meetingDescriptionTextView.text = meetingSafe.meetingDescription
        }
    }
    private func setupMeetingDate() {
        guard let meetingSafe = meeting else {return}
        let currentDate = meetingSafe.meetingDate
        let calendar = Calendar.current

  
        meetingDatePicker.minimumDate = calendar.startOfDay(for: currentDate)
        
       
        let oneMonthFromNow = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        meetingDatePicker.maximumDate = oneMonthFromNow
        
        let selectedDate = meetingDatePicker.date
        
      
        meetingStartTimePicker.minimumDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: selectedDate)
        
        meetingStartTimePicker.maximumDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: selectedDate)
        
        meetingEndTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 30, to: meetingStartTimePicker.date)
        meetingEndTimePicker.maximumDate = Calendar.current.date(byAdding: .hour, value: 3, to: meetingStartTimePicker.date)
        
    }
    
    @IBAction func meetingStartTimePicker(_ sender: UIDatePicker) {
        meetingEndTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 30, to: meetingStartTimePicker.date)
        meetingEndTimePicker.maximumDate = Calendar.current.date(byAdding: .hour, value: 3, to: meetingStartTimePicker.date)
    }
    
    @IBAction func meetingDatePicker(_ sender: UIDatePicker) {
        setupMeetingDate()
    }
    
    
    @IBAction func editInvitedEmployeesButton(_ sender: UIButton) {
        if meetingTitleTextField.text?.isEmpty ?? true || meetingDescriptionTextView.text.isEmpty {
            showAlert(title: "Empty Sections", message: "Please fill meeting title and description to porceed.")
        } else {
            
            if let meetingTitle = meetingTitleTextField.text, let meetingDescription = meetingDescriptionTextView.text, let companySafe = company {
                guard let meeting = meeting else {return}
                let isMeetingExist = companySafe.meetings.contains { $0.meetingTitle == meetingTitle}
                if isMeetingExist && meetingTitle != meeting.meetingTitle {
                    showAlert(title: "Fail", message: "There is a meeting already registered with the same title. Please change the title and try again.")
                } else {
                    if meeting.meetingDate != meetingDatePicker.date || meeting.meetingStartTime != meetingStartTimePicker.date || meeting.meetingEndTime != meetingEndTimePicker.date {
                 
                        let resetInvitedUserList: [Employee] = []
                        meetingDetails =
                        [
                            Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: meetingTitle,
                            Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: meetingDescription,
                            Constant.Dictionary.MeetingDetailsDictionary.meetingDate: meetingDatePicker.date,
                            Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: meetingStartTimePicker.date,
                            Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: meetingEndTimePicker.date,
                            Constant.Dictionary.MeetingDetailsDictionary.invitedEmployeeList: resetInvitedUserList
                        ]
                    } else {
                   
                        meetingDetails =
                        [
                            Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: meetingTitle,
                            Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: meetingDescription,
                            Constant.Dictionary.MeetingDetailsDictionary.meetingDate: meetingDatePicker.date,
                            Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: meetingStartTimePicker.date,
                            Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: meetingEndTimePicker.date
                        ]
                      
                    }
                    
                    
                    performSegue(withIdentifier: Constant.Segue.Manager.Meeting.EditMeeting.editDetailsToInviteEmployee, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Meeting.EditMeeting.editDetailsToInviteEmployee {
            if let employeeListVC = segue.destination as? MeetingEditEmployeeListViewController {
                employeeListVC.company = company
                employeeListVC.meeting = meeting
                employeeListVC.meetingDetails = meetingDetails
            }
        }
    }
}


extension MeetingEditDetailsViewController {
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
}


