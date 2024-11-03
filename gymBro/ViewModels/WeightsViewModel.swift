//
//  WeightsViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 03/11/24.
//

import Foundation

class WeightsViewModel {
    //Depedency Injection
    private var exerciseService: ExerciseServiceProtocol
    
    init (exerciseService: ExerciseServiceProtocol = ExerciseService.shared) {
        self.exerciseService = exerciseService
    }
    
    
    
}
