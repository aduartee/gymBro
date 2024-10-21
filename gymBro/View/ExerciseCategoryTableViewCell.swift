//
//  ExerciseCategoryTableViewCell.swift
//  gymBro
//
//  Created by Arthur Duarte on 20/10/24.
//

import UIKit

class ExerciseCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var tryView: UIView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        tryView.layer.cornerRadius = 25.0
        tryView.layer.masksToBounds = true
    }
    
    func configureCell(exerciseName: String, weekDay: String?) {
        exerciseNameLabel.text = exerciseName
        weekDayLabel.text = weekDay ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
}
