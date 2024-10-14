import Foundation
import FirebaseFirestore


class FirestoreExerciseService: ExerciseDatabaseService {
    private var db = Firestore.firestore()
    
    func fetchExerciseDocument(idCategory: String, userId: String, completion: @escaping (Result<[QueryDocumentSnapshot], NSError>) -> Void) {
        db.collection("users").document(userId).collection("categoryExercices").document(idCategory).collection("exercices").getDocuments { querySnapshot, error in
            
            if let error = error as? NSError {
                completion(.failure(error))
            }
                
            switch FirestoreDocumentUtil.isDocumentExistDocuments(querySnapshot) {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let queryDocuments):
                completion(.success(queryDocuments))
            }
        }
    }
    
    func fetchExerciseDocumentById(idCategory: String, exerciseId: String, userId: String, completion: @escaping (Result<DocumentSnapshot, NSError>) -> Void) {
        
        db.collection("users").document(userId).collection("categoryExercices").document(idCategory).collection("exercices").document(exerciseId).getDocument { document, error in
            if let error = error as? NSError {
                completion(.failure(error))
            }
            
            switch FirestoreDocumentUtil.isDocumentExistData(document) {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let document):
                completion(.success(document))
            }
        }
    }
    
    func fetchExerciseCollection(idCategory: String, userId: String) -> CollectionReference {
        return db.collection("users").document(userId).collection("categoryExercices").document(idCategory).collection("exercices")
    }
    
    func registerExerciseFirabase(exerciseData: [String: Any], exerciseCollection: CollectionReference, completion: @escaping (Result <DocumentReference, NSError>) -> Void) {
        
        let documentReference = exerciseCollection.addDocument(data: exerciseData) { error in
              // Se houver erro, retorna no completion
              if let error = error as NSError? {
                  completion(.failure(error))
                  return
              }
          }
        
        completion(.success(documentReference))
    }
    
    func editExerciseFirebase(exerciseEditedData: [String: Any], exerciseDocument: DocumentReference, completion: @escaping (Result<Bool, ExerciseErrorEnum>) -> Void) {
        exerciseDocument.updateData(exerciseEditedData) { error in
            if error != nil {
                completion(.failure(ExerciseErrorEnum.errorEdit))
            }
            
            completion(.success(true))
        }
    }
}
