//
//  ExerciseViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 25/08/24.
//

import Foundation

class ExerciseViewModel {
    private var exerciseService: ExerciseServiceProtocol
    private var exerciseCategoryService:ExerciseCatergoryServiceProtocol
    
    init(exerciseService: ExerciseServiceProtocol = ExerciseService.shared, exerciseCategoryService: ExerciseCatergoryServiceProtocol = ExerciseCategoryService.shared) {
        self.exerciseService = exerciseService
        self.exerciseCategoryService = exerciseCategoryService
    }
    
    func fetchExerciceCategoryById(categoryId:String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        exerciseCategoryService.fetchExerciseCategoryById(categoryId: categoryId) { categoryExercise, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(categoryExercise, nil)
        }
    }
    
    func fetchAllExercicesCategory(categoryId: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void ){
        exerciseService.fetchAllExercices(idCategory: categoryId) { exercise, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(exercise, nil)
        }
    }
}
