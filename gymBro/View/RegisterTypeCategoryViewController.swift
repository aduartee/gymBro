//
//  RegisterTypeCategoryViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 04/08/24.
//

import UIKit

class RegisterTypeCategoryViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    func configureLayout() {
        self.navigationItem.title = "New Category"
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 14
    }
    
    
    
}
