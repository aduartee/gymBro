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
    
    public func fetchWeightDocument(weightCollection: CollectionReference, completion: @escaping  (Result<[QueryDocumentSnapshot], NSError>) -> Void ) {
        weightCollection.getDocuments() { querySnapshot, error in
            if let error = error as? NSError {
                completion(.failure(error))
            }
            
            switch FirestoreDocumentUtil.isDocumentExistDocuments(querySnapshot) {
            case .failure(let error):
                completion(.failure(error))
            
            
            case .success(let document):
                completion(.success(document))
            }
        }
    }
    
    public func fetchWeigthCollection(userId: String, categoryId: String, exerciseId: String) -> CollectionReference {
        return db.collection("users").document(userId).collection("categoryExercices").document(categoryId).collection("exercices").document(exerciseId).collection("weightTracker")
    }
    
    
    
}
