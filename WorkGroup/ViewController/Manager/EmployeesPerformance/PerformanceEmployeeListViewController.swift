//
//  PerformanceEmployeeListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class PerformanceEmployeeListViewController: UIViewController {
    @IBOutlet weak var performanceDateListTableView: UITableView!
    private let employeeList = ["Employee1", "Employee2", "Employee3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        performanceDateListTableView.delegate = self
        performanceDateListTableView.dataSource = self
        navigationItem.title = "Employee List"
    }
    

    @IBAction func mainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    

}

extension PerformanceEmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = performanceDateListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.employeeListForPerformanceReportCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = employeeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Segue.Manager.employeeListToPerformanceDate, sender: self)
    }
    
}
