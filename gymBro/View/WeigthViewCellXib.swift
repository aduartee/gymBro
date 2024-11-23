//
//  WeigthViewCellXib.swift
//  gymBro
//
//  Created by Arthur Duarte on 19/11/24.
//

import UIKit

class WeigthViewCellXib: UITableViewCell {

    @IBOutlet weak var numberOfSeriesLabel: UILabel!
    @IBOutlet weak var weightNumberLabel: UILabel!
    @IBOutlet weak var repsNumberLabel: UILabel!

    @IBOutlet weak var difficultEmojiLabel: UILabel!
    @IBOutlet weak var backgroudView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureBackgroundView()
    }
    
    func changeInfoRegistered(weight: String, reps: String, difficult: String) {
        weightNumberLabel.text = weight
        repsNumberLabel.text = reps
        difficultEmojiLabel.text = difficult
    }
    
    func configureBackgroundView() {
        backgroudView.layer.masksToBounds = true
        backgroudView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
