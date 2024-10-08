//
//  EditExerciseViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 03/09/24.
//

import Foundation

class EditExerciseViewModel {
    private var exerciseService = ExerciseService.shared
    private var idCategory: String
    private var exerciseId: String
    
    init(idCategory: String, exerciseId: String) {
        self.idCategory = idCategory
        self.exerciseId = exerciseId
    }
    
    func getExerciseById(completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        exerciseService.fetchExerciseById(idCategory: idCategory, exerciseId: exerciseId) { exercise, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(exercise, nil)
            
        }
    }
    
    func editExercise(exerciseEdit: ExerciseRequest, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        exerciseService.editExercise(categoryId: self.idCategory, exerciseRequest: exerciseEdit) { exercise, error in
            if let error = error {
                completion(nil, error)
                return
            }
                                
            completion(exercise, nil)
        }
        
    }
}
