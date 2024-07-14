//
//  ViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 12/07/24.
//

import UIKit

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
}

