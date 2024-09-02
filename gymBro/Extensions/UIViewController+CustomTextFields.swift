//
//  UIViewController+CustomTextFields.swift
//  gymBro
//
//  Created by Arthur Duarte on 29/08/24.
//

import UIKit

extension UIViewController{
    func customTextFields(to arrayTextFieldsInView: [UITextField]?) {
        guard let arrayTextFieldsInView = arrayTextFieldsInView else { return }
        
        for field in arrayTextFieldsInView {
            field.layer.cornerRadius = 8.0
            field.layer.masksToBounds = true
            field.layer.borderColor = UIColor.lightGray.cgColor
            field.layer.borderWidth = 1.0
            field.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
            field.leftView = paddingView
            field.leftViewMode = .always
            
            field.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            field.attributedPlaceholder = NSAttributedString(
                string: "Type here:",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            
            field.layer.shadowColor = UIColor.black.cgColor
            field.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            field.layer.shadowOpacity = 0.2
            field.layer.shadowRadius = 4.0
        }
    }
}
