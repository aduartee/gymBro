//
//  ExerciseService.swift
//  gymBro
//
//  Created by Arthur Duarte on 25/08/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ExerciseService {
    public static let shared = ExerciseService()
    private let db = Firestore.firestore()
    private init() {}
    
    private func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    private func createNSError(domain: String, description: String) -> NSError {
        return NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    public func fetchExerciseCategoryById(categoryId: String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        guard let uid = getUserId() else {
            let error = createNSError(domain: "AuthError", description: "No current user")
            completion(nil, error)
            return
        }
        
        db.collection("users").document(uid).collection("categoryExercices").document(categoryId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                let documentError = self.createNSError(domain: "FirebaseError", description: "Exercise does not exist, register a new exercise and try again")
                completion(nil, documentError)
                return
            }
            
            let exerciseCategory = CategoryExerciseRequest(
                id: categoryId,
                categoryName: data["name"] as? String ?? "",
                description: data["description"] as? String ?? "",
                weekDay: data["weekDay"] as? String ?? ""
            )
            
            completion(exerciseCategory, nil)
        }
    }
    
    public func fetchAllExercices(idCategory: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void) {
        guard let uid = getUserId() else {
            let error = createNSError(domain: "AuthError", description: "No current user")
            completion(nil, error)
            return
        }
        
        db.collection("users").document(uid).collection("categoryExercices").document(idCategory).collection("exercices").getDocuments { querySnapshot, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                let documentError = self.createNSError(domain: "FirebaseError", description: "Exercise does not exist, register a new exercise and try again")
                completion(nil, documentError)
                return
            }
            
            var exercisesModel: [ExerciseRequest] = []
            
            for document in documents {
                let data = document.data()
                let id = document.documentID
                let name: String = data["name"] as? String ?? ""
                let series: Int = data["series"] as? Int ?? 0
                let repetitions: Int = data["repetitions"] as? Int ?? 0
                let exerciseInstance = ExerciseRequest(id: id, name: name, series: series, repetitions: repetitions)
                exercisesModel.append(exerciseInstance)
            }
            
            completion(exercisesModel, nil)            
        }
    }
}
