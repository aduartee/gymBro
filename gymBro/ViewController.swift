//
//  ViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 12/07/24.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var gymBroImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        animateLogo()
    }
    
    func configureLayout() {
        signInButton.layer.masksToBounds = true
        signInButton.layer.cornerRadius = 12
        self.navigationItem.hidesBackButton = true
        testDatabaseInclude()
    }
    
    func testDatabaseInclude() {
        let email = "chuck norris"
        let username = "chuck norris"
//        let password = ""
        
        let userInstace = RegisterUserRequest(email: email, username: username, password: password)
        
        AuthService.shared.registerUser(user: userInstace) { data, error in
            if let error = error as NSError? {
                if error.domain == AuthErrorDomain {
                    switch error.code {
                    
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.showCustomAlert(title: "Warning", message: "The email address is badly formatted.")
                        return
                    
                    default:
                        self.showCustomAlert(title: "Error", message: "Ops, error: \(error.localizedDescription)")
                        return
                    }
                }
                
            }
            
            self.showCustomAlert(title: "Success", message: "The user was registered")
        }
    }
    
    func animateLogo() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,  options: [.curveEaseInOut], animations: {
            self.gymBroImage.frame = CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height / 2 - 50, width: 100, height: 100)
            
        }, completion: nil)
    }
    
    @IBAction func singUpTap(_ sender: Any) {
        if let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            
            navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    func showCustomAlert(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
