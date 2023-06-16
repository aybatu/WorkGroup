//
//  ViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 06/06/2023.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserAccounts()
    }
    
    
    func fetchUserAccounts() {
        // Display the loading screen
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        present(loadingViewController, animated: false, completion: nil)

        // Simulate asynchronous network request
        DispatchQueue.global().async {
            // Perform the network request to fetch user accounts information
            // Replace this with your actual network request code
            // For example, using URLSession or Alamofire
            
            // Simulate delay for demonstration purposes
            Thread.sleep(forTimeInterval: 2.0)

            // When the network request is complete, dismiss the loading screen
            DispatchQueue.main.async {
                loadingViewController.dismiss(animated: false) {
                    // Handle the fetched user accounts information
                    // For example, update your UI with the retrieved data
                }
            }
        }
    }

}
