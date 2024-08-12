//
//  EditCategoryViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 01/08/24.
//

import UIKit

class EditCategoryViewController: UIViewController {
    var idCategory:String?
    @IBOutlet weak var exerciceField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    var editExerciceCategoryVM = EditExerciceCategoryViewModel()
    let daysOfWeek: [String] =
    [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    var selectedValuePicker: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let idCategory = idCategory else { return }
        getExerciceCategory(idExerciceCategory: idCategory)
    }
    
    func getExerciceCategory(idExerciceCategory: String) {
        editExerciceCategoryVM.getDataExerciceCategory(idExerciceCategory: idExerciceCategory) { [weak self] exerciseCategory, error in
            guard let self = self else { return }
            
        }
    }
}

extension EditCategoryViewController: UIPickerViewDataSource {
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

extension EditCategoryViewController:UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValuePicker = daysOfWeek[row]
    }
}
