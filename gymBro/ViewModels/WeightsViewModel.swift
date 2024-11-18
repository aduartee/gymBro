//
//  WeightsViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 03/11/24.
//

import Foundation

class WeightsViewModel: WeightsViewModelProtocol {
    //Depedency Injection
    private var exerciseService: ExerciseServiceProtocol
    private var weightService: WeightsServiceProtocol
    
    init (exerciseService: ExerciseServiceProtocol = ExerciseService.shared, weightService: WeightsServiceProtocol = WeightService.shared) {
        self.exerciseService = exerciseService
        self.weightService = weightService
    }
    
    func getExerciseData(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        exerciseService.fetchExerciseById(idCategory: idCategory, exerciseId: exerciseId) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(data, nil)
        }
    }
}
