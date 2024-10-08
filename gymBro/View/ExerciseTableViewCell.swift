import UIKit

class ExerciseTableViewCell: UITableViewCell {
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    
    func configureCell(name: String, series: String, orderNumber: String) {
        exerciseLabel.text = name
        seriesLabel.text = "Series: \(series)"
        orderLabel.text = orderNumber
    }
}


