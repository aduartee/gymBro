//
//  SignInViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 14/07/24.
//

import Foundation

struct SignInViewModel {
    var email: String = ""
    var password: String = ""
    
    func signIn(completion: @escaping (Error?) -> Void) {
        let signInUserRequest = SignInUserRequest(email: email, password: password)
        AuthService.shared.singInUser(with: signInUserRequest) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
}
