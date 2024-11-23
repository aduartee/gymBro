//
//  addNewWeightModalViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 21/11/24.
//

import UIKit

protocol AddWeightDelegate: AnyObject {
    func didAddWeight(selectedRowPicker: String)
}

class addNewWeightModalViewController: UIViewController {
    var weigthValues: [String] = []
    weak var delegate: AddWeightDelegate?
    var selectedRowPicker: String = ""
    @IBOutlet weak var weightPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        configureUIPickerView()
        setupPresentationController()
    }
    
    func setupPickerView() {
        weightPicker.delegate = self
        weightPicker.dataSource = self
    }
    
    func setupPresentationController() {
        presentationController?.delegate = self
    }
    
    func configureUIPickerView() {
        for i in 1...400 {
            weigthValues.append("\(i) kg")
        }
    }
}

extension addNewWeightModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weigthValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weigthValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRowPicker = weigthValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? UILabel()
        pickerLabel.text = String(weigthValues[row])
        pickerLabel.font = UIFont(name: "Helvetica", size: 30)
        pickerLabel.textColor = .systemBlue
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}

extension addNewWeightModalViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.didAddWeight(selectedRowPicker: selectedRowPicker)
    }
}
