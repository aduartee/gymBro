import Firebase
import Foundation

protocol WeightDatabaseServiceProtocol {
    func fetchWeightDocument(weightCollection: CollectionReference, completion: @escaping  (Result<[QueryDocumentSnapshot], NSError>) -> Void )
        
    func registerNewWeight(weightData: [String: Any], weightCollection: CollectionReference, completion: @escaping (Result<DocumentReference, NSError>) -> Void)
    
    func fetchWeigthCollection(userId: String, categoryId: String, exerciseId: String) -> CollectionReference
}

