//
//  ExerciseViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 25/08/24.
//

import Foundation

class ExerciseViewModel {
    func fetchExerciceCategoryById(categoryId:String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        ExerciseService.shared.fetchExerciseCategoryById(categoryId: categoryId) { categoryExercise, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(categoryExercise, nil)
        }
    }
    
    func fetchAllExercicesCategory(categoryId: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void ){
        ExerciseService.shared.fetchAllExercices(idCategory: categoryId) { [weak self] exercise, error in
            guard let self = self else { return }
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(exercise, nil)
            
        }
    }
}
