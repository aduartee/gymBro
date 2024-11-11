//
//  RegisterWeightViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 06/11/24.
//

import UIKit

class RegisterWeightViewController: UIViewController {

    private var weightLiftedValue: Int = 0
    var numberOfReps: [Int] = []
    var selectedOption: Int = 0
    let cardContent: [String]  = ["Easy 🐔", "Medium 🐯", "Hard 🔥"]
    let cardContentColors: [UIColor] = [
        UIColor(red: 173/255, green: 216/255, blue: 255/255, alpha: 1.0),
        UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1.0),
        UIColor(red: 28/255, green: 59/255, blue: 159/255, alpha: 1.0)
    ]
    var currentIndex: Int = 0
    
    @IBOutlet weak var difficultButton: UIButton!
    @IBOutlet weak var weightLiftedField: UITextField!
    @IBOutlet weak var numberOfRepsPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeightLiftedField()
        configurePickerData()
        styleDifficultButton()
    }
    
    private func configurePickerData() {
        self.numberOfRepsPicker.delegate = self
        self.numberOfRepsPicker.dataSource = self
        for number in 1...20 {
            numberOfReps.append(number)
        }
    }
    
    private func configureWeightLiftedField() {
        UIView.transition(with: weightLiftedField, duration: 0.1, options: .transitionCrossDissolve, animations: {
               self.weightLiftedField.text = "\(self.weightLiftedValue) kg"
           })
    }
    
    private func styleDifficultButton() {
        difficultButton.layer.cornerRadius = difficultButton.frame.height / 2
       difficultButton.clipsToBounds = true
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .medium)
        ]
        let attributedTitle = NSAttributedString(string: difficultButton.title(for: .normal) ?? "Easy 🐔", attributes: attributes)
        difficultButton.setAttributedTitle(attributedTitle, for: .normal)
        UIButton.transition(with: difficultButton, duration: 0.3, options: .transitionCurlUp) { [weak self] in
            guard let self = self else { return }
            self.difficultButton.backgroundColor = self.cardContentColors[self.currentIndex]
        }
    }
    
    private func changeButtonContent(){
        let buttonContent = cardContent[currentIndex]
        difficultButton.setTitle(buttonContent, for: .normal)
        styleDifficultButton()
    }
    
    @IBAction func tapChangeDifficult(_ sender: Any) {
        currentIndex = (currentIndex + 1) % cardContent.count
        changeButtonContent()
    }
    
    @IBAction func tapPlusButton(_ sender: Any) {
        weightLiftedValue += 2
        configureWeightLiftedField()
    }
    
    @IBAction func tapMinusButton(_ sender: Any) {
        if weightLiftedValue > 0 {
            weightLiftedValue -= 2
            configureWeightLiftedField()
        }
    }
}

extension RegisterWeightViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numberOfReps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numberOfReps[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? UILabel()
        pickerLabel.text = String(numberOfReps[row])
        pickerLabel.font = UIFont(name: "Helvetica", size: 30)
        pickerLabel.textColor = .systemBlue
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = numberOfReps[row]
    }
}
