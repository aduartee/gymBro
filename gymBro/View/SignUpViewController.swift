//
//  SignUpViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 13/07/24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var registerUserViewModel: RegisterUserViewModel = RegisterUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    func configureLayout() {
        self.navigationItem.hidesBackButton = true
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func singUpButton(_ sender: Any) {
        registerUserViewModel.email = emailTextField.text ?? ""
        registerUserViewModel.username = usernameTextField.text ?? ""
        registerUserViewModel.password  = passwordTextField.text ?? ""
        let password = registerUserViewModel.password
        let confirmPassword = confirmPasswordTextField.text ?? ""
        let passwordValidate = registerUserViewModel.validateEqualsPasswords(with: password, with: confirmPassword)
        
        if !passwordValidate {
            showCustomAlert(title: "Warning", message: "Passwords don't match")
            return
        }
        
        registerUserViewModel.registerUser { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showCustomAlert(title: "Error", message: "Error: \(error.localizedDescription)")
                return
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
}
