//
//  EmployeeListTableCell.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 25/06/2023.
//

import UIKit

class EmployeeListTableCell: UITableViewCell {
    
    @IBOutlet weak var employeeAccountTypeLabel: UILabel!
    @IBOutlet weak var employeeEmailAddressLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
