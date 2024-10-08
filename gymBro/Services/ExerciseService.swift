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
                let series: String = data["series"] as? String ?? ""
                let repetitions: Int = data["repetitions"] as? Int ?? 0
                let date: Date = data["date"] as? Date ?? Date()
                let exerciseInstance = ExerciseRequest(id: id, name: name, series: series, repetitions: repetitions, date: date)
                exercisesModel.append(exerciseInstance)
            }
            
            completion(exercisesModel, nil)            
        }
    }
    
    public func fetchExerciseById(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        guard let uid = getUserId() else {
            let error = createNSError(domain: "AuthError", description: "No current user")
            completion(nil, error)
            return
        }
        
        let userDocument = db.collection("users").document(uid)

        print(idCategory)
        print(exerciseId)
        
        userDocument.collection("categoryExercices").document(idCategory).collection("exercices").document(exerciseId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                let error = self.createNSError(domain: "FirebaseError", description: "Exercise doesn't exist")
                completion(nil, error)
                return
            }
            
            let exerciseInstace = ExerciseRequest(
                id: exerciseId,
                name: data["name"] as? String ?? "",
                series: data["series"] as? String ?? "",
                repetitions: data["repetitions"] as? Int ?? 1,
                date: data["date"] as? Date ?? Date()
            )
            
            completion(exerciseInstace, nil)
        }
    }
    
    public func registerNewExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        guard let uid = getUserId() else {
            let error = createNSError(domain: "AuthError", description: "No current user")
            completion(nil, error)
            return
        }
        
        let exerciseCollection = db.collection("users").document(uid).collection("categoryExercices").document(categoryId).collection("exercices")
        
        let exerciseName: String = exerciseRequest.name
        let series: String = exerciseRequest.series
        let reps: Int = exerciseRequest.repetitions
        let date: Date = exerciseRequest.date
        
        let exerciseData: [String: Any] = [
            "name": exerciseName,
            "series": series,
            "repetitions" : reps,
            "date" : date
        ]
        
        let documentReference = exerciseCollection.addDocument(data: exerciseData) { error in
            if let error = error {
                completion(nil, error)
                return
            }
        }
        
        let exerciseInstance = ExerciseRequest(id: documentReference.documentID, name: exerciseName, series: series, repetitions: reps, date: date)
        completion(exerciseInstance, nil)
    }
    
    public func editExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping(ExerciseRequest?, Error?) -> Void) {
        guard let uid = getUserId() else {
            let error = createNSError(domain: "AuthError", description: "No current user")
            completion(nil, error)
            return
        }
        
        let exerciseId = exerciseRequest.id
        let exerciseDocument = db.collection("users").document(uid).collection("categoryExercices").document(categoryId).collection("exercices").document(exerciseId)
        let exerciseName: String = exerciseRequest.name
        let series: String = exerciseRequest.series
        let reps: Int = exerciseRequest.repetitions
        let date: Date = exerciseRequest.date
        
        let dataToSend: [String : Any] = [
            "name": exerciseName,
            "series": series,
            "repetitions" : reps,
            "date" : date
        ]
        
        exerciseDocument.updateData(dataToSend) { error in
            if error != nil {
                let error = self.createNSError(domain: "FirebaseError", description: "Error to edit exercise")
                completion(nil, error)
                return
            }
            
            completion(exerciseRequest, nil)
        }
        
    }
}
