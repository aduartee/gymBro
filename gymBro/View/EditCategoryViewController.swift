//
//  EditCategoryViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 01/08/24.
//

import UIKit

class EditCategoryViewController: UIViewController {
    var idCategory:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let idCategory = idCategory else { return }
        print(idCategory)
    }
}
