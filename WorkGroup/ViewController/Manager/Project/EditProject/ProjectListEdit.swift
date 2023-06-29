//
//  EditProjectViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 14/06/2023.
//

import UIKit

class ProjectListEdit: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var projectListTable: UITableView!
    var company: RegisteredCompany?
    let projectList: [String] = ["Project1", "Project2", "Project3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        projectListTable.delegate = self
        projectListTable.dataSource = self
        navigationItem.title = "Project List"
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
            cell.textLabel?.text =  companyArr[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Manager.projectListToProjectDetails, sender: self)
    }
}
