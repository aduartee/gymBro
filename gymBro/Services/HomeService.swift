//
//  HomeService.swift
//  gymBro
//
//  Created by Arthur Duarte on 26/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class HomeService {
    
    public static let shared = HomeService()
    private let dbFirebase = Firestore.firestore()
    
    private init() {}
    
    func getUsernameCurrentUser(completion: @escaping (String?, Error?) -> Void) {
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }
    
        let userReference = dbFirebase.collection("users").document(uidCurrentUser)
        
        userReference.getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                let username = document.get("username") as? String
                completion(username, nil)
            } else {
                let noDataError = NSError(domain: "FirestoreError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Document does not exist or username field is missing"])
                completion(nil, noDataError)
                return
            }
        }
    }
    
    func getTypeExercicesByCurrentUser(completion: @escaping ([CategoryExerciseRequest]?, Error?) -> Void) {
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }
        
        // Get the user document by current user
        let userDocument = dbFirebase.collection("users").document(uidCurrentUser)
        userDocument.collection("categoryExercices").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
                        
            guard let documents = querySnapshot?.documents else {
                completion(nil, NSError(domain: "FirestoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No documents found"]))
                return
            }
            
            var categoryExercices: [CategoryExerciseRequest] = []

            for document in documents {
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let description: String? = data["description"] as? String ?? ""
                let wekDay = data["weekDay"] as? String ?? ""
                let categoryExercice = CategoryExerciseRequest(id: id, categoryName: name, description: description, weekDay: wekDay)
                categoryExercices.append(categoryExercice)
            }
                        
            completion(categoryExercices, nil)
        }
    }
    
    func getExerciceCategoryById(categoryExerciceId: String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else {
            completion(nil ,NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }
        
        let userDocument = dbFirebase.collection("users").document(uidCurrentUser)
        userDocument.collection("categoryExercices").document(categoryExerciceId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil, NSError(domain: "FirebaseError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"]))
                return
            }
         
            let categoryExercice = CategoryExerciseRequest(
                id: categoryExerciceId,
                categoryName: data["name"] as? String ?? "",
                description: data["description"] as? String ?? "",
                weekDay: data["weekDay"] as? String ?? ""
            )
            
            completion(categoryExercice, nil)
        }
    }
    
    func saveExerciceCategory(categoryExercise: CategoryExerciseRequest ,completion: @escaping (String?, Error?) -> Void) {
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }
        
        let categoryName = categoryExercise.categoryName
        let description = categoryExercise.description ?? ""
        let weekDay = categoryExercise.weekDay ?? ""
        let documentUser = dbFirebase.collection("users").document(uidCurrentUser)
        let categoryExercice = documentUser.collection("categoryExercices")
        
        let categoryData: [String: String] = [
            "name": categoryName,
            "description": description,
            "weekDay": weekDay
        ]
        
        let documentReference = categoryExercice.addDocument(data: categoryData) { error in
            if let error = error {
                completion(nil, error)
                return
            }
        }
        
        completion(documentReference.documentID, nil)
    }
    
    func deleteExerciseCategory(categoryExerciceId: String, completion: @escaping (Error?) -> Void) {
        guard !categoryExerciceId.isEmpty else {
            completion(NSError(domain: "FirebaseError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Document path cannot be empty."]))
            return
        }
        
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }
        
        let categoryExercice = dbFirebase.collection("users").document(uidCurrentUser).collection("categoryExercices").document(categoryExerciceId)
        
        categoryExercice.delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
