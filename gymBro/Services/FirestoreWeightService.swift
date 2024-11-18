import Firebase
import FirebaseFirestore
import Foundation

class FirestoreWeightService: WeightDatabaseServiceProtocol {
    private let db = Firestore.firestore()
    
    public func registerNewWeight(weightData: [String: Any], weightCollection: CollectionReference, completion: @escaping (Result<DocumentReference, NSError>) -> Void) {
        
        let documentReference = weightCollection.addDocument(data: weightData) { error in
            if let error = error as? NSError{
                completion(.failure(error))
                return
            }
        }
        
        completion(.success(documentReference))
    }
    
    public func fetchWeigthCollection(userId: String, categoryId: String, exerciseId: String) -> CollectionReference {
        return db.collection("users").document(userId).collection("categoryExercices").document(categoryId).collection("exercises").document(exerciseId).collection("weightTracker")
    }
    
    
    
}
