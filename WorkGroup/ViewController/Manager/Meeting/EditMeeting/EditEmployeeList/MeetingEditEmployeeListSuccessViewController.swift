//
//  MeetingEditEmployeeListSuccessViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditEmployeeListSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    
    @IBAction func backToEditMeetingButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        let viewControllers = navigationController.viewControllers
        
        if viewControllers.count > 0 {
            let meetingListViewController = viewControllers[1]
            navigationController.popToViewController(meetingListViewController, animated: true)
        }
    }
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}
