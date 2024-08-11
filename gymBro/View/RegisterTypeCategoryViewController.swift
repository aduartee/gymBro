//
//  RegisterTypeCategoryViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 04/08/24.
//

import UIKit

class RegisterTypeCategoryViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    @IBOutlet weak var exerciseNameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    weak var delegate: CategoryExerciseDelegate?
    var registerTypeCategoryVM = CategoryExerciceViewModel()
    var dataTableViewHome: [CategoryExerciseRequest]?
    
    let daysOfWeek: [String] = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    var selectedOption: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weekDayPicker.dataSource = self
        self.weekDayPicker.delegate = self
        configureLayout()
    }
    
    func configureLayout() {
        self.navigationItem.title = "New Category"
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 14
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        let categoryName = exerciseNameField.text ?? ""
        let description = descriptionField.text ?? ""
        // If the variable is empty, the default value is "Sunday" because it's the first value in the picker :)
        let weekDay = !(selectedOption.isEmpty) ? selectedOption : "Sunday"
        
        if categoryName.isEmpty || description.isEmpty {
            showCustomAlert(title: "Warning", message: "The fields are empty")
            return
        }
        
        registerTypeCategoryVM.categoryName = categoryName
        registerTypeCategoryVM.description = description
        registerTypeCategoryVM.weekDay = weekDay
        
        //Called and passed the values to the ViewModel
        registerTypeCategoryVM.registerExerciceCategory { [weak self] category, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showCustomAlert(title: "Warning", message: "\(error)")
                return
            }
            
            if let category = category {
                print(category)
                delegate?.didAddCategoryExercise(newCategory: category)
            }
            
            dismiss(animated: true)
        }
        
    }
}

extension RegisterTypeCategoryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysOfWeek.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfWeek[row]
    }
}

extension RegisterTypeCategoryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = daysOfWeek[row]
    }
}
