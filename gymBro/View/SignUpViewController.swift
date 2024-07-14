//
//  SignUpViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 13/07/24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let crazyConditionTesterInitial:Bool = true
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
        navigationController?.popViewController(animated: true)
    }
}
