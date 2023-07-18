//
//  EditProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectListEdit: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var projectListTable: UITableView!
    var company: Company?
    private var project: Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        projectListTable.delegate = self
        projectListTable.dataSource = self
        navigationItem.title = "PROJECT LIST"
    }
    

   

}

extension ProjectListEdit {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return company?.projects.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectListTable.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.editProjectListCellIdentifier, for: indexPath)
        if let company = company{
            let companyArr = Array(company.projects)
            cell.textLabel?.text =  companyArr[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let company = self.company {
            self.project = Array(company.projects)[indexPath.row]
            performSegue(withIdentifier: Constant.Segue.Manager.Project.EditProject.projectListToProjectDetails, sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.Manager.Project.EditProject.projectListToProjectDetails {
            if let projectDetailsVC = segue.destination as? ProjectDetailsEditViewController {
                projectDetailsVC.project = project
                projectDetailsVC.company = company
            }
        }
    }
}
