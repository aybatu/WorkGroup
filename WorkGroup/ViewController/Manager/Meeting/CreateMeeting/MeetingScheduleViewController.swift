//
//  MeetingScheduleViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingScheduleViewController: UIViewController {
    @IBOutlet weak var meetingTitleTextField: UITextField!
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    @IBOutlet weak var meetingDatePicker: UIDatePicker!
    @IBOutlet weak var meetingEndTimePicker: UIDatePicker!
    @IBOutlet weak var meetingStartTimePicker: UIDatePicker!
    @IBOutlet weak var inviteEmployeeButton: UIButton!
    
    var company: RegisteredCompany?
    private let textViewStyle = TextView()
    private let textFieldStyle = TextFieldStyle()
    
    private var meetingDetails: [String: Any?] = [
        Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetingDate: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: nil,
        Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: nil
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMeetingDate()
        styleTextArea()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func styleTextArea() {
        textViewStyle.styleTextView(meetingDescriptionTextView)
        textFieldStyle.styleTextField(meetingTitleTextField)
    }
    private func setupMeetingDate() {
        let currentDate = Date()
        let calendar = Calendar.current

        if let oneDayAfterCurrentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            meetingDatePicker.minimumDate = calendar.startOfDay(for: oneDayAfterCurrentDate)
        }
       
        let oneMonthFromNow = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        meetingDatePicker.maximumDate = oneMonthFromNow
        
        let selectedDate = meetingDatePicker.date
        
      
        meetingStartTimePicker.minimumDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: selectedDate)
        
        meetingStartTimePicker.maximumDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: selectedDate)
        
        meetingEndTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 30, to: meetingStartTimePicker.date)
        meetingEndTimePicker.maximumDate = Calendar.current.date(byAdding: .hour, value: 3, to: meetingStartTimePicker.date)
    }
    @IBAction func meetingDatePicker(_ sender: UIDatePicker) {
        setupMeetingDate()
    }
    
    @IBAction func meetingStartTimePicker(_ sender: UIDatePicker) {
        meetingEndTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 30, to: meetingStartTimePicker.date)
        meetingEndTimePicker.maximumDate = Calendar.current.date(byAdding: .hour, value: 3, to: meetingStartTimePicker.date)
    }
    
    @IBAction func inviteEmployeesButton(_ sender: UIButton) {
        if meetingTitleTextField.text?.isEmpty ?? true || meetingDescriptionTextView.text.isEmpty {
            showAlert(title: "Empty Sections", message: "Please fill meeting title and description to porceed.")
        } else {
            
            if let meetingTitle = meetingTitleTextField.text, let meetingDescription = meetingDescriptionTextView.text, let companySafe = company {
                let isMeetingExist = companySafe.meetings.contains { $0.meetingTitle == meetingTitle}
                if isMeetingExist {
                   showAlert(title: "Fail", message: "There is a meeting already registered with the same title. Please change the title and try again.")
                } else {
                    meetingDetails = [Constant.Dictionary.MeetingDetailsDictionary.meetingTitle: meetingTitle,
                                      Constant.Dictionary.MeetingDetailsDictionary.meetindDescription: meetingDescription,
                                      Constant.Dictionary.MeetingDetailsDictionary.meetingDate: meetingDatePicker.date,
                                      Constant.Dictionary.MeetingDetailsDictionary.meetingStartTime: meetingStartTimePicker.date,
                                      Constant.Dictionary.MeetingDetailsDictionary.meetindEndTime: meetingEndTimePicker.date]
                    
                    performSegue(withIdentifier: Constant.Segue.Manager.Meeting.ScheduleMeeting.meetingDetailsToEmployeeList, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Meeting.ScheduleMeeting.meetingDetailsToEmployeeList {
            if let employeeListVC = segue.destination as? MeetingInviteEmployeeViewController {
                employeeListVC.company = company
                employeeListVC.meetingDetails = meetingDetails
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Okay", style: .default)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
}

