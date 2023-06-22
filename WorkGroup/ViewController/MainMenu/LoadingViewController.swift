import UIKit

class LoadingViewController: UIViewController {
    var registrationNumber: String?
    var emailAddress: String?
    var password: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        // Configure the activity indicator
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        // Add the activity indicator to the view
        view.addSubview(activityIndicator)

   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
