//
//  RegisterWeigthViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 14/11/24.
//

class RegisterWeigthViewModel {
    private var weightService: WeightsServiceProtocol
    
    init (weightService: WeightsServiceProtocol = WeightService.shared) {
        self.weightService = weightService
    }
    
    func registerNewWeight(exerciseId: String, categoryId: String, WeightRequest: WeightsRequest, completion: @escaping (WeightsRequest?, Error?) -> Void) {
        weightService.registerWeigth(exerciseId: exerciseId, categoryId: categoryId, weightRequest: WeightRequest) { weightData, error in
            if let error = error {
                completion(nil, error)
            }
            
            completion(weightData, nil)
        }
    }
    
    
}
