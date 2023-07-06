//
//  MeetingEditDetailsViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 15/06/2023.
//

import UIKit

class MeetingEditDetailsViewController: UIViewController {
    
    @IBOutlet weak var meetingTitleTextField: UITextField!
    
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    
    
    private var isSave = true
    private let styleTextView = TextView()
    private let styleTextField = TextFieldStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Meeting Details"
    }
    
    private func styleTextArea() {
        styleTextView.styleTextView(meetingDescriptionTextView)
        styleTextField.styleTextField(meetingTitleTextField)
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
//        if isSave {
//            performSegue(withIdentifier: Constant.Segue.Manager.meetingEditSaveToSuccess, sender: self)
//        }else {
//            performSegue(withIdentifier: Constant.Segue.Manager.meetingEditSaveToFail, sender: self)
//        }
    }
    
    @IBAction func editInvitedEmployeesButton(_ sender: UIButton) {
        
    }
    @IBAction func discardButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard?", preferredStyle: .alert)
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
            self.performDiscard()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(discardAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    private func performDiscard() {
        guard let navigationController = self.navigationController else {return}
        navigationController.popViewController(animated: true)
    }
}
