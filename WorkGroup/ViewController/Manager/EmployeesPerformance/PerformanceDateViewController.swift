//
//  PerformanceDateViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class PerformanceDateViewController: UIViewController {
    @IBOutlet weak var performanceDateListTableView: UITableView!
    private let dateList = ["01/01/23 - 01/02/23", "01/02/23 - 01/03/23", "01/03/23 - 01/04/23"]
    override func viewDidLoad() {
        super.viewDidLoad()
        performanceDateListTableView.delegate = self
        performanceDateListTableView.dataSource = self
        
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
    @IBAction func employeeListbutton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    

}

extension PerformanceDateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = performanceDateListTableView.dequeueReusableCell(withIdentifier: Constant.TableCellIdentifier.Manager.employeePerformanceDateCellIdentifier, for: indexPath)
        cell.textLabel?.text = dateList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.Manager.performanceDateToPerformanceGraph, sender: self)
    }
}
