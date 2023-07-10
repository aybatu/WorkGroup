//
//  EmployeeMeetingDetailsViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeeMeetingDetailsViewController: UIViewController {
    
    @IBOutlet weak var meetingTitleLabel: UILabel!
    
    @IBOutlet weak var meetingDateLabel: UILabel!
    @IBOutlet weak var meetingEndDateLabel: UILabel!
    @IBOutlet weak var meetingStartDateLabel: UILabel!
    @IBOutlet weak var meetingDescriptionLabel: UILabel!
    var meeting: Meeting?
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    private lazy var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    

    private func loadData() {
        if let meetingTitle = meeting?.meetingTitle,
            let meetingDescription = meeting?.meetingDescription,
            let meetingDate = meeting?.meetingDate,
            let meetingStartTime = meeting?.meetingStartTime,
            let meetingEndTime = meeting?.meetingEndTime {
            
            meetingTitleLabel.text = meetingTitle
            meetingDescriptionLabel.text = meetingDescription
            meetingDateLabel.text = dateFormatter.string(from: meetingDate)
            meetingStartDateLabel.text = timeFormatter.string(from: meetingStartTime)
            meetingEndDateLabel.text = timeFormatter.string(from: meetingEndTime)
        }
    }

}
