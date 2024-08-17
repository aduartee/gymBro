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
    weak var delegate:EditCategoryExerciseDelegate?
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
        weekDayPicker.delegate = self
        weekDayPicker.dataSource = self
        getExerciceCategory(idExerciceCategory: idCategory)
    }
    
    func getExerciceCategory(idExerciceCategory: String) -> Void {
        editExerciceCategoryVM.getDataExerciceCategory(idExerciceCategory: idExerciceCategory) { [weak self] exerciseCategory, error in
            guard let self = self else { return }
            
            if let error = error {
                showCustomAlert(title: "Warning", message: "\(error)")
                return
            }
            
            guard let exerciseCategory = exerciseCategory else { return }
            exerciceField.text = exerciseCategory.categoryName
            descriptionField.text = exerciseCategory.description
            let weekDayData: String = exerciseCategory.weekDay ?? ""
            if let index = self.daysOfWeek.firstIndex(of: weekDayData), !weekDayData.isEmpty {
                self.weekDayPicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    @IBAction func saveButtonTap(_ sender: Any) {
        guard let idCategory = idCategory else { return }
        
        let categoryExerciceInstance = CategoryExerciseRequest(
            id: idCategory,
            categoryName: exerciceField.text ?? "",
            description: descriptionField.text ?? "",
            weekDay: ((selectedValuePicker?.isEmpty) == nil) ? selectedValuePicker : "Sunday"
        )
        
        editExerciceCategoryVM.callEditExerciceCategory(categoryExercise: categoryExerciceInstance) { [weak self] categoryExercise, error in
            guard let self = self else { return }
            if let error = error {
                self.showCustomAlert(title: "Warning", message: "\(error)")
                return
            }
            
            if let categoryExercise = categoryExercise {
                self.delegate?.didEditCategoryExercise(categoryExercice: categoryExercise)
                self.dismiss(animated: true)
            }
        }
    }
}



extension EditCategoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysOfWeek.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfWeek[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValuePicker = daysOfWeek[row]
    }
}

extension EditCategoryViewController:EditCategoryExerciseDelegate {
    func didEditCategoryExercise(categoryExercice: CategoryExerciseRequest) {
        
    }
}
