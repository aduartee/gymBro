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
    var signInViewModel = SignInViewModel()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        animateLogo()
    }
    
    func configureLayout() {
        signInButton.layer.masksToBounds = true
        signInButton.layer.cornerRadius = 12
        self.navigationItem.hidesBackButton = true
        passwordTextField.isSecureTextEntry = true
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
    
    @IBAction func signInTap(_ sender: Any) {
        signInViewModel.email = emailTextField.text ?? ""
        signInViewModel.password = passwordTextField.text ?? ""

        signInViewModel.signIn { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showCustomAlert(title: "Error", message: "Error: \(error.localizedDescription)")
                return
            }
                        
            // Verifique se o storyboard está correto
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(homeVC, animated: true)
                }
            } else {
                print("Não foi possível instanciar o HomeViewController")
            }
        }
    }

    func showCustomAlert(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
