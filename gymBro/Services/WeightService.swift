//
//  WeightService.swift
//  gymBro
//
//  Created by Arthur Duarte on 10/11/24.
//

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
    
    private func buildWeigthData(weight: Int, repetitions: Int, sets: String, difficult: String) -> [String: Any] {
        let data: [String: Any] = [
            "weight": weight,
            "repetitions": repetitions,
            "sets" : sets,
            "difficult" : difficult
        ]
        
        return data
    }
    
    func registerWeigth(exerciseId: String, categoryId: String, weightRequest: WeightsRequest, completion: @escaping (WeightsRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil,  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let weigthData = buildWeigthData(weight: weightRequest.weight, repetitions: weightRequest.repetitions, sets: weightRequest.sets, difficult: weightRequest.difficult)
        
        let weigthCollection = databaseService.fetchWeigthCollection(userId: userId, categoryId: categoryId, exerciseId: exerciseId)
        
        databaseService.registerNewWeight(weightData: weigthData, weightCollection: weigthCollection) { referenceDocumentWeight in
            switch referenceDocumentWeight {
            case .failure(let error) :
                completion(nil, error)
                
            case .success(let referenceDocument):
                let dataNewWeight = WeightsRequest(
                    exerciseId: weightRequest.exerciseId,
                    weightId: referenceDocument.documentID,
                    weight: weightRequest.weight,
                    repetitions: weightRequest.repetitions,
                    sets: weightRequest.sets,
                    difficult: weightRequest.difficult)
                
                completion(dataNewWeight, nil)
            }
        }
    }
    
    
}
