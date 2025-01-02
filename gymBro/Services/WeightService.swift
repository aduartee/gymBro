//
//  WeightService.swift
//  gymBro
//
//  Created by Arthur Duarte on 10/11/24.
//

import Foundation
import FirebaseFirestore

class WeightService: WeightsServiceProtocol {
    public static let shared = WeightService()
    var databaseService: WeightDatabaseServiceProtocol
    var userId:String? {
        switch FirebaseUserService.shared.getAuthenticatedUserId() {
        case .success(let id):
            return id
        case .failure(_):
            return nil
        }
    }
    
    private init(databaseService: WeightDatabaseServiceProtocol = FirestoreWeightService()) {
        self.databaseService = databaseService
    }
    
    private func createWeightDataForFirebase(weight: Int, repetitions: Int, sets: Int, difficult: Difficult, registerAt: Date) -> [String: Any] {
        let data: [String: Any] = [
            "weight": weight,
            "repetitions": repetitions,
            "sets" : sets,
            "difficult" : difficult.label,
            "registerAt" : registerAt
        ]
        
        return data
    }
    
    internal func buildWeightRequest(documents: [QueryDocumentSnapshot], exerciseId: String) -> [WeightsRequest] {
        var weigthRequestData: [WeightsRequest] = []
        
        for document in documents {
            let data = document.data()
            let weightRequest = createWeightData(data, document, exerciseId)
            weigthRequestData.append(weightRequest)
        }
        
        return weigthRequestData
    }
    
    internal func createWeightData(_ data: [String: Any], _ document: QueryDocumentSnapshot, _ exerciseId: String) -> WeightsRequest {
        let exerciseId = exerciseId
        let weightId = document.documentID
        let weight = data["weight"] as? Int ?? 1
        let repetitions = data["repetitions"] as? Int ?? 1
        let sets = data["sets"] as? Int ?? 1
        let difficult = createDifficult(from: data["difficult"] as? String ?? "")
        let registerAt: Date = createRegisterDate(data["registerAt"] as? Timestamp)
        return WeightsRequest(exerciseId: exerciseId, weightId: weightId, weight: weight, repetitions: repetitions, sets: sets, difficult: difficult, registerAt: registerAt)
    }
    
    internal func createRegisterDate(_ registerAt: Timestamp?) -> Date {
        if let registerTimestamp = registerAt {
            return registerTimestamp.dateValue()
        }
    
        return Date.now
    }
    
    internal func createDifficult(from value: String) -> Difficult {
        switch value.lowercased() {
        case "easy":
            return Difficult(emoji: "🐔", label: "Easy", color: .green)
        case "medium":
            return Difficult(emoji: "🐯", label: "Medium", color: .orange)
        case "hard":
            return Difficult(emoji: "🔥", label: "Hard", color: .red)
        default:
            return Difficult(emoji: "🐔", label: "Easy", color: .green)
        }
    }
    
    func fetchWeightData(categoryId: String, exerciseId: String, completion: @escaping ([WeightsRequest?], Error?) -> Void) {
        guard let userId = self.userId else {
            completion([nil],  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let weightCollection = self.databaseService.fetchWeigthCollection(userId: userId, categoryId: categoryId, exerciseId: exerciseId)
        
        self.databaseService.fetchWeightDocument(weightCollection: weightCollection) { weigthDocument in
            switch weigthDocument {
            case .failure(let error):
                completion([nil], error)
                
            case .success(let documents):
                let buildWeightRequest = self.buildWeightRequest(documents: documents, exerciseId: exerciseId)
                completion(buildWeightRequest, nil)
            }
        }
        
    }
    
    func registerWeigth(exerciseId: String, categoryId: String, weightRequest: [Int:WeightsRequest], completion: @escaping ([WeightsRequest?], Error?) -> Void) {
        guard let userId = self.userId else {
            completion([nil],  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let weigthCollection = databaseService.fetchWeigthCollection(userId: userId, categoryId: categoryId, exerciseId: exerciseId)
        let dispatchGroup = DispatchGroup()
        var weightResults: [WeightsRequest] = []
        var errors: [Error] = []
        
        for (_, weightData) in weightRequest {
            dispatchGroup.enter()
            let data = createWeightDataForFirebase(weight: weightData.weight, repetitions: weightData.repetitions, sets: weightData.sets, difficult: weightData.difficult, registerAt: weightData.registerAt)
            
            databaseService.registerNewWeight(weightData: data, weightCollection: weigthCollection) { referenceDocumentWeight in
                switch referenceDocumentWeight {
                case .failure(let error) :
                    errors.append(error)
                    
                case .success(let referenceDocument):
                    let dataNewWeight = WeightsRequest(
                        exerciseId: weightData.exerciseId,
                        weightId: referenceDocument.documentID,
                        weight: weightData.weight,
                        repetitions: weightData.repetitions,
                        sets: weightData.sets,
                        difficult: weightData.difficult,
                        registerAt: weightData.registerAt)
                    
                    weightResults.append(dataNewWeight)
                }
            }
            // The task end
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if !errors.isEmpty {
                completion([nil], errors.first)
            }
            
            completion(weightResults, nil)
        }
    }

}



