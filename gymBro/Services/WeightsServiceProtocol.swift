//
//  Untitled.swift
//  gymBro
//
//  Created by Arthur Duarte on 13/11/24.
//

protocol WeightsServiceProtocol {
    func registerWeigth(exerciseId: String, categoryId: String, weightRequest: WeightsRequest, completion: @escaping (WeightsRequest?, Error?) -> Void)
    
    
    
}
