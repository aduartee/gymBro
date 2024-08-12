//
//  EditExerciceCategoryViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 10/08/24.
//

import Foundation

struct EditExerciceCategoryViewModel {
    var id: String = ""
    var categoryName: String = ""
    var description: String? = ""
    var weekDay: String? = ""
    
    func getDataExerciceCategory(idExerciceCategory: String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        HomeService.shared.getExerciceCategoryById(categoryExerciceId: idExerciceCategory) { categoryExercice, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(categoryExercice, nil)
        }
    }
}
