//
//  Untitled.swift
//  gymBro
//
//  Created by Arthur Duarte on 13/11/24.
//
import FirebaseFirestore

protocol WeightsServiceProtocol {
    func fetchWeightData(categoryId: String, exerciseId: String, completion: @escaping ([WeightsRequest?], Error?) -> Void)
    func registerWeigth(exerciseId: String, categoryId: String, weightRequest: [Int:WeightsRequest], completion: @escaping ([WeightsRequest?], Error?) -> Void)
    func createDifficult(from value: String) -> Difficult
    func createWeightData(_ data: [String: Any], _ document: QueryDocumentSnapshot, _ exerciseId: String) -> WeightsRequest
    func buildWeightRequest(documents: [QueryDocumentSnapshot], exerciseId: String) -> [WeightsRequest]
}
