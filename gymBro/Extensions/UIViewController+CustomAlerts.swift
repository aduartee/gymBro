//
//  UIViewController+Alerts.swift
//  gymBro
//
//  Created by Arthur Duarte on 19/07/24.
//

import UIKit

extension UIViewController {
    func showCustomAlert(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
