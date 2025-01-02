//
//  WeightTableViewCell.swift
//  gymBro
//
//  Created by Arthur Duarte on 15/12/24.
//

import UIKit

class WeightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weightStyleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayLabelView: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightLabelOfView: UILabel!
    @IBOutlet weak var repsNumberLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var difficultLabel: UILabel!
    @IBOutlet weak var counterWeightLabel: UILabel!
    @IBOutlet weak var viewMonths: UIView!
    @IBOutlet weak var viewWeight: UILabel!
    @IBOutlet weak var repsView: UIView!
    @IBOutlet weak var difficultView: UIView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var repsLabelOfView: UILabel!
    @IBOutlet weak var backgroundViewAllCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleFonts()
        styleRoundViews()
    }
    
    func styleFonts() {
        weightStyleLabel.font = UIFont(name: "Montserrat-Medium", size: 22.0)
        dayLabel.font = UIFont(name: "Montserrat-SemiBold", size: 22.0)
        repsNumberLabel.font = UIFont(name: "Montserrat-SemiBold", size: 22.0)
        weightLabel.font = UIFont(name: "Montserrat-SemiBold", size: 22.0)
        difficultLabel.font =  UIFont(name: "Montserrat-Bold", size: 15.0)
        counterWeightLabel.font =  UIFont(name: "Montserrat-Medium", size: 16.0)
        dayLabelView.font =  UIFont(name: "Montserrat-Bold", size: 14.0)
        weightLabelOfView.font =  UIFont(name: "Montserrat-SemiBold", size: 13.0)
        repsLabelOfView.font =  UIFont(name: "Montserrat-SemiBold", size: 13.0)
    }
    
    func styleRoundViews() {
        viewMonths.layer.cornerRadius = 5.0
        weightView.layer.cornerRadius = 5.0
        repsView.layer.cornerRadius = 5.0
        difficultView.layer.cornerRadius = 5.0
        counterView.layer.cornerRadius = 10.0
        backgroundViewAllCell.layer.cornerRadius = 20.0
    }
    
    func changeInfoWeight(weight: Int, reps: Int, serie: String, day: String) {
        weightLabel.text = "\(weight)"
        repsNumberLabel.text = "\(reps)"
        counterWeightLabel.text = serie
        dayLabel.text = day
    }
    
    func styleDifficult(difficult: String, difficultColor: UIColor) {
        difficultLabel.text = difficult
        difficultView.backgroundColor = difficultColor
    }
    
}
