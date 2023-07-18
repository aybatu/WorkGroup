//
//  ViewController.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 06/06/2023.
//

import UIKit

class LunchScreenViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingLabel = UILabel()
    private lazy var reachability: Reachability? = {
        return Reachability()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        
        // Configure the loading label
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "Loading WorkGroup..."
        loadingLabel.textColor = .white
        loadingLabel.font = .boldSystemFont(ofSize: 16.0)
        
        
        // Add subviews
        view.addSubview(activityIndicator)
        view.addSubview(loadingLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8.0),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setGradientBackground()
        
        checkInternetConnection()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let reachabilitySafe = reachability {
            reachabilitySafe.stopMonitoring()
        }
        
    }
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension LunchScreenViewController {
    
    private func checkInternetConnection() {
        if let reachabilitySafe = reachability {
            
            reachabilitySafe.connectionStatusChangedHandler = { [weak self] isConnected in
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    
                    if isConnected {
                        
                        self?.dismiss(animated: false) {
                            self?.performSegue(withIdentifier: "LoadingToMainMenu", sender: self)
                        }
                        
                    } else {
                        
                        let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to continue.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
            reachabilitySafe.startMonitoring()
        }
    }
}
