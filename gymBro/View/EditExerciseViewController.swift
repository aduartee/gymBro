//
//  EditExerciseViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 03/09/24.
//

import UIKit

class EditExerciseViewController: UIViewController {
    var idCategory: String?
    var exerciseId: String?
    var editExerciseVM: EditExerciseViewModel?
    weak var delegate: EditExerciseDelegate?
    var numberOfSeries: [Int] = []
    let arraySeries: [String] =  ["2x", "3x", "4x"]
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var seriesSegmentControl: UISegmentedControl!
    @IBOutlet weak var repsPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let exerciseId = exerciseId else { return }
        guard let idCategory = idCategory else { return }
        getExerciseById(idCategory: idCategory, exerciseId: exerciseId)
        configurePickerView()
        configureSegmentedControl()
        repsPickerView.delegate = self
        repsPickerView.dataSource = self
    }
    
    func configureSegmentedControl() {
        seriesSegmentControl.removeAllSegments()
        for (i, item) in arraySeries.enumerated() {
            seriesSegmentControl.insertSegment(withTitle: item, at: i, animated: true)
        }
        seriesSegmentControl.selectedSegmentIndex = 0
    }
    
    private func configurePickerView() {
        for number in 1...20 {
            numberOfSeries.append(number)
        }
    }
    
    private func getExerciseById(idCategory: String, exerciseId: String) {
        let editExerciseViewModel = EditExerciseViewModel(
            idCategory: idCategory,
            exerciseId: exerciseId
        )
        
        editExerciseViewModel.getExerciseById { [weak self] exercise, error in
            guard let self = self else { return }
            if let error = error {
                self.showCustomAlert(title: "Warning", message: "\(error.localizedDescription)")
            }
            
            if let exercise = exercise {
                configureInfoView(exercise: exercise)
            }
        }
    }
    
    private func configureInfoView(exercise: ExerciseRequest) {
        exerciseField.text = exercise.name
        if let rowIndex = numberOfSeries.firstIndex(of: exercise.repetitions) {
            repsPickerView.selectRow(rowIndex, inComponent: 0, animated: true)
        }
        
        let titleSegment = "\(exercise.series)x"
        if let segmentIndex = arraySeries.firstIndex(of: titleSegment) {
            seriesSegmentControl.selectedSegmentIndex = segmentIndex
        } else {
            seriesSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
    
    @IBAction func editExerciseTap(_ sender: Any) {
        
        guard let exerciseId = exerciseId else { return}
        let selectedIndex = repsPickerView.selectedRow(inComponent: 0)
        let selectedRow = numberOfSeries[selectedIndex]
        let exerciseRequest = ExerciseRequest(
            id: exerciseId,
            name: exerciseField.text ?? "",
            series: seriesSegmentControl.selectedSegmentIndex,
            repetitions: selectedRow
        )
        
        delegate?.didEditExerciseDelegate(exerciseRequest: exerciseRequest)
        dismiss(animated: true)
    }
    
}

extension EditExerciseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfSeries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numberOfSeries[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = String(numberOfSeries[row])
        let attributedTitle = NSAttributedString(string: titleData, attributes: [
            .font: UIFont(name: "Helvetica", size: 21.0)!,
            .foregroundColor: UIColor.systemBlue
        ])
        
        return attributedTitle
    }
}


