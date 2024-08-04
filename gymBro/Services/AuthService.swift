//
//  AuthService.swift
//  gymBro
//
//  Created by Arthur Duarte on 14/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AuthService {
    public static let shared = AuthService()
    
    private init() {}

    
    /// This method is used to register new user
    /// - Parameters:
    ///   - user: Information about the user who will be registered in the app - email, username, and password.
    ///   - completion: The completion had two parametres
    ///   - Bool: Determines if the user was resgistered in app, if is true the user were saved in Database normaly.
    ///   - Error: Is an optional value because it can exist or not, depending on the server's response.
    public func registerUser(user: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
        
        let email = user.email
        let username = user.username
        let password = user.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            // Get the result of User in Database
            guard let result = result?.user else {
                completion(false, nil)
                return
            }
            
            // Database Instance
            let databaseFirestore = Firestore.firestore()
            
            // Insert the user inforation into the colletion users
            databaseFirestore.collection("users").document(result.uid).setData(
                [
                    "email" : email,
                    "username" : username,
                ]) { error in
                    if let error = error {
                        completion(true, error)
                        return
                    }
                }

            completion(true, nil)
        }
    }
    
    
    /// This method is used to Sigin users on app
    /// - Parameters:
    ///   - user: Informations about authenticated user - Received this parametres: email and password
    ///   - completion: The completion have one parametres
    ///   - Error?: Is an optional value because it can exist or not, depending on the server's response.
    func singInUser(with user: SignInUserRequest, completion: @escaping (Error?) -> Void) {
        let email = user.email
        let password = user.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func logoutUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
      
}
