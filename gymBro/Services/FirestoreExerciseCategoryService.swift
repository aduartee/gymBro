import Foundation
import Firebase
import FirebaseFirestore


/// This class is responsible for retrieving category data from Firestore database.
class FirestoreExerciseCategoryService:ExerciseCategoryDatabaseService {
    private let db = Firestore.firestore()
    
    /// This method is responsible for retrieving data from Firebase based on the provided category ID and the current user ID.
    /// - Parameters:
    ///   - userId: The ID of the authenticated user, used to fetch the correct data associated with that user.
    ///   - categoryId: The ID of the category registered by the user.
    ///   - completion: A closure that returns either the fetched document or an NSError if the operation fails.
    public func fetchCategoryDocument(userId: String, categoryId: String, completion: @escaping (Result<DocumentSnapshot, NSError>) -> Void) {
        db.collection("users").document(userId).collection("categoryExercices").document(categoryId).getDocument { document, error in
            if let error = error as? NSError {
                completion(.failure(error))
                return
            }
            
            switch FirestoreDocumentUtil.isDocumentExistData(document) {
            case .success(let document):
                completion(.success(document))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
