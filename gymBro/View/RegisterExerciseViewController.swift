//
//  RegisterExerciseViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 28/08/24.
//

import UIKit

class RegisterExerciseViewController: UIViewController {
    @IBOutlet weak var seriesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var exerciseNameTextLabel: UITextField!
    @IBOutlet weak var numberOfRepsPicker: UIPickerView!
    weak var delegate: RegisterExerciseDelegate?
    var registerViewModel: RegisterExerciseViewModel?
    var idCategory: String?
    var numberOfSeries: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickersInView: [UITextField] = [exerciseNameTextLabel]
        customTextFields(to: pickersInView)
        numberOfRepsPicker.delegate = self
        numberOfRepsPicker.dataSource = self
        configurePickerReps()
        configureSegmentedControl()
    }
    
    func configureSegmentedControl() {
        let arraySeries =  ["2x", "3x", "4x"]
        
        seriesSegmentedControl.removeAllSegments()
        for (i, item) in arraySeries.enumerated() {
            seriesSegmentedControl.insertSegment(withTitle: item, at: i, animated: true)
        }
        seriesSegmentedControl.selectedSegmentIndex = 0
    }
    
    func configurePickerReps() {
        for i in 1...20 {
            numberOfSeries.append(String(i))
        }
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let idCategory = self.idCategory else { return }
        guard let exerciseName = exerciseNameTextLabel.text, !exerciseName.isEmpty else {
            showCustomAlert(title: "Warning", message: "The name of exercise can't be empty")
            return
        }
        let selectedSerieIndex = seriesSegmentedControl.selectedSegmentIndex
        let selectedSerieValue = seriesSegmentedControl.titleForSegment(at: selectedSerieIndex)
        let selectedRow = numberOfRepsPicker.selectedRow(inComponent: 0)
        let selectedRepValue = numberOfSeries[selectedRow]
        
        registerViewModel = RegisterExerciseViewModel(
            categoryId: idCategory,
            name: exerciseName,
            series: selectedSerieValue ?? "",
            repetitions: Int(selectedRepValue) ?? 1
        )
        
        guard let registerVM = registerViewModel else { return }
        
        registerVM.registerExercise { [weak self ] exercise, error in
            guard let self = self else { return }
            
            if let error = error {
                showCustomAlert(title: "Warning", message: "\(error)")
                return
            }
            
            if let exerciseData = exercise {
                delegate?.didRegisterExerciseDelegate(exerciseRequest: exerciseData)
                dismiss(animated: true)
            }
        }
    }
}

extension RegisterExerciseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfSeries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfSeries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
           let titleData = numberOfSeries[row]
           let attributedTitle = NSAttributedString(string: titleData, attributes: [
               .font: UIFont(name: "Helvetica", size: 21.0)!,
               .foregroundColor: UIColor.systemBlue
           ])
           
           return attributedTitle
       }
}
