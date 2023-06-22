//
//  MeetingCreateSuccessfulViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingCreateSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    
    @IBAction func createNewMeetingButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        let viewControllers = navigationController.viewControllers
        if viewControllers.count > 0 {
            let scheduleMeetingView = viewControllers[1]
            navigationController.popToViewController(scheduleMeetingView, animated: true)
        }
    }
    
    
    @IBAction func backToMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
}
