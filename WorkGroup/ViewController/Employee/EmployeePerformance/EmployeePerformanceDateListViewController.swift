//
//  EmployeePerformanceDateListViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 16/06/2023.
//

import UIKit

class EmployeePerformanceDateListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var dateListTableView: UITableView!
    let dateList = ["01/01/23 - 01/02/23", "01/02/23 - 01/03/23", "01/03/23 - 01/04/23"]
    override func viewDidLoad() {
        super.viewDidLoad()

        dateListTableView.delegate = self
        dateListTableView.dataSource = self
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dateListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Employee.employeePerformanceDateListCellIdentifier, for: indexPath)
        cell.textLabel?.text = dateList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.Employee.employeeDateListToPerformanceGraph, sender: self)
    }
}
