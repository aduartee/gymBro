//
//  addRepsViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 23/11/24.
//

import UIKit

protocol addRepsDelegate: AnyObject {
    func didAddReps(selectedRepsValue: Int)
}

class addRepsViewController: UIViewController {
    @IBOutlet weak var repsPickerView: UIPickerView!
    var dataReps: [Int] = []
    var selectedReps: Int = 1
    var delegate: addRepsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRangeOfReps()
        setupPickerView()
        setupPresentationController()
    }
    
    func setupPickerView() {
        repsPickerView.delegate = self
        repsPickerView.dataSource = self
    }
    
    func setupPresentationController() {
        presentationController?.delegate = self
    }
    
    func createRangeOfReps() {
        for i in 1...20 {
            dataReps.append(i)
        }
    }
}

extension addRepsViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataReps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(dataReps[row])x"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? UILabel()
        pickerLabel.text = "\(dataReps[row])x"
        pickerLabel.font = UIFont(name: "Helvetica", size: 30)
        pickerLabel.textColor = .systemBlue
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedReps = dataReps[row]
    }
}

extension addRepsViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
       delegate?.didAddReps(selectedRepsValue: selectedReps)
    }
}
