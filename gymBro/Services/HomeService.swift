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
                print(data)
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let categoryExercice = CategoryExerciseRequest(id: id, categoryName: name)
                categoryExercices.append(categoryExercice)
            }
                        
            completion(categoryExercices, nil)
        }
    }
}
