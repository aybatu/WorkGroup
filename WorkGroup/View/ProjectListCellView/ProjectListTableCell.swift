//
//  ProjectListTableCell.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 06/08/2023.
//

import UIKit

class ProjectListTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
