//
//  MeetingCellView.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 03/08/2023.
//

import UIKit

class MeetingListTableCell: UITableViewCell {
    @IBOutlet weak var meetingDateLabel: UILabel!
    @IBOutlet weak var meetingTitleLabel: UILabel!
    @IBOutlet weak var meetingDescriptionLabel: UILabel!
    @IBOutlet weak var meetingEndTimeLabel: UILabel!
    @IBOutlet weak var meetingStartTimeLabel: UILabel!
    @IBOutlet weak var meetingTimeProgressBar: UIProgressView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
