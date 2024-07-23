//
//  HomeViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 18/07/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    let currentUser = Auth.auth().currentUser?.displayName ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        AuthService.shared.logoutUser { error in
            if let error = error {
                print(error)
                return
            }
            
            self.goToSingInVC()
        }
    }
    
    func configureLayout() {
        self.navigationItem.hidesBackButton = true
        usernameLabel.text = "Hello, \(currentUser) 👋"
        
    }
    
    func goToSingInVC(){
        if let signInVc = storyboard?.instantiateViewController(withIdentifier: "singInViewController") as? ViewController {
            navigationController?.pushViewController(signInVc, animated: true)
        }
    }

}
