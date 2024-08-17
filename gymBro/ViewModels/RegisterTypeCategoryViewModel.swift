//
//  RegisterTypeCategoryViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 07/08/24.
//

import Foundation

struct CategoryExerciceViewModel {
    var categoryName: String = ""
    var description: String? = ""
    var weekDay: String? = ""
    
    public func registerExerciceCategory(completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        let categoryExercise = CategoryExerciseRequest(id: "", categoryName: categoryName, description: description, weekDay: weekDay)
        
        HomeService.shared.saveExerciceCategory(categoryExercise: categoryExercise) { categoryExerciceId, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let categoryExerciceId = categoryExerciceId {
//                Make a copy from the categoryExercise object, to get pass the correct id
                var updatedCategoryExercise = categoryExercise
                updatedCategoryExercise.id = categoryExerciceId
                completion(updatedCategoryExercise, nil)
            } else {
                completion(nil, NSError(domain: "FirebaseError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve document ID"]))
            }
        }
    }
}
