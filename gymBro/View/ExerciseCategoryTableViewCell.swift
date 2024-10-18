//
//  ExerciseCategoryTableViewCell.swift
//  gymBro
//
//  Created by Arthur Duarte on 17/10/24.
//

import UIKit

class ExerciseCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameTextLabel: UILabel!
    @IBOutlet weak var daysOfWeekTextLabel: UILabel!
    
    func configureCell(categoryName: String, daysOfWeek: String?) {
        categoryNameTextLabel.text = categoryName
        daysOfWeekTextLabel.text =  daysOfWeek ?? ""
    }
}
