//
//  EditProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectListEdit: UIViewController {
    @IBOutlet weak var projectListTable: UITableView!
    var company: Company?
    private var project: Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        projectListTable.delegate = self
        projectListTable.dataSource = self
        
        projectListTable.register(UINib(nibName: Constant.CustomCell.projectListCellNib, bundle: nil), forCellReuseIdentifier: Constant.CustomCell.projectListTableCellIdentifier)
        navigationItem.title = "PROJECT LIST"
        
    }
    
    private func progressCalculator(startDate: Date, endDate:Date) -> Float {
        let currentDate = Date()
        
        let totalTime = endDate.timeIntervalSince(startDate)
        let passedTime = currentDate.timeIntervalSince(startDate)
        
        let clampedPassedTime = max(0, min(passedTime, totalTime))
        
        return Float(clampedPassedTime) / Float(totalTime)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Project.EditProject.projectListToProjectDetails {
            if let projectDetailsVC = segue.destination as? ProjectDetailsEditViewController {
                projectDetailsVC.project = project
                projectDetailsVC.company = company
            }
        }
    }
    
    private func alert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        
        // Check if an alert is already being presented
        if presentedViewController == nil {
            present(alert, animated: true)
        }
    }
    
}

extension ProjectListEdit: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return company?.projects.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectListTable.dequeueReusableCell(withIdentifier: Constant.CustomCell.projectListTableCellIdentifier, for: indexPath) as! ProjectListTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let company = company{
            let companyArr = company.projects
            cell.titleLabel.text =  companyArr[indexPath.row].title
            cell.descriptionLabel.text =  companyArr[indexPath.row].description
            cell.startDateLabel.text = "Start date: \(dateFormatter.string(from:  companyArr[indexPath.row].startDate))"
            cell.endDateLabel.text = "End date: \(dateFormatter.string(from:  companyArr[indexPath.row].endDate))"
            cell.progressBar.progress = progressCalculator(startDate:  companyArr[indexPath.row].startDate, endDate:  companyArr[indexPath.row].endDate)
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let company = self.company {
            self.project = Array(company.projects)[indexPath.row]
            performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.projectListToProjectDetails, sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let registrationNo = company?.registrationNumber, let projects = company?.projects else { return nil }
        let projectService = ProjectService()
        let checkAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            projectService.markProjectCompleted(registrationNumber: registrationNo, project: projects[indexPath.row]) { isProjectComplete, error in
                DispatchQueue.main.async {
                    if isProjectComplete {
                        completionHandler(true)
                    } else {
                        self.alert(message: error ?? "There was an error, please try again.")
                        completionHandler(false)
                    }
                }
            }
        }
        
        // Customize the appearance of the check action
        checkAction.image = UIImage(systemName: "checkmark.circle.fill")
        checkAction.backgroundColor = UIColor.systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [checkAction])
        configuration.performsFirstActionWithFullSwipe = false 
        
        return configuration
    }
    
}
