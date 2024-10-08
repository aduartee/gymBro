//
//  RegisterExerciseViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 30/08/24.
//

import Foundation

class RegisterExerciseViewModel {
    private var exerciseService = ExerciseService.shared
    private var categoryId: String
    private var name: String
    private var series: String
    private var repetitions: Int
    
    init(categoryId: String, name: String, series: String, repetitions: Int) {
        self.categoryId = categoryId
        self.name = name
        self.series = series
        self.repetitions = repetitions
    }
    
    public func registerExercise(completion: @escaping (ExerciseRequest?, Error?) -> Void ) {
        let exerciseRequest = ExerciseRequest(id: "", name: self.name, series: self.series, repetitions: self.repetitions, date: Date())
        exerciseService.registerNewExercise(categoryId: self.categoryId, exerciseRequest: exerciseRequest) { exerciseData, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(exerciseData, nil)
        }
    }
}
