import Foundation
import Firebase

protocol ExerciseDatabaseService {
    func fetchExerciseDocument(idCategory: String, userId: String, completion: @escaping (Result <[QueryDocumentSnapshot], NSError>) -> Void)
    
    func fetchExerciseDocumentById(idCategory: String, exerciseId: String, userId: String, completion: @escaping (Result<DocumentSnapshot, NSError>) -> Void)
    
    func fetchExerciseCollection(idCategory: String, userId: String) -> CollectionReference
    
    func editExerciseFirebase(exerciseEditedData: [String: Any], exerciseDocument: DocumentReference, completion: @escaping (Result<Bool, ExerciseErrorEnum>) -> Void)
}

