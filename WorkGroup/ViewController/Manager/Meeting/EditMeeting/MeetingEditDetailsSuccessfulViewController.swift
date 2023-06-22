//
//  MeetingEditDetailsSuccessfulViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditDetailsSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    

    @IBAction func backToMeetingsButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        let viewControllers = navigationController.viewControllers
        if viewControllers.count > 0 {
            let meetingList = viewControllers[1]
            navigationController.popToViewController(meetingList, animated: true)
        }
    }
    
    @IBAction func backToMainMenuButton(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {return}
        navigationController.popToRootViewController(animated: true)
       
    }

}
