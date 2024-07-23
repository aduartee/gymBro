//
//  SingUpViewModel .swift
//  gymBro
//
//  Created by Arthur Duarte on 19/07/24.
//

import Foundation

struct RegisterUserViewModel {
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    func registerUser(completion: @escaping (Error?) -> Void) {
        let singUpRequestModel = RegisterUserRequest(
            email: self.email,
            username: self.username,
            password: self.password
        )
        
        AuthService.shared.registerUser(user: singUpRequestModel) { success, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func validateEqualsPasswords(with password: String, with confirmPassword: String) -> Bool {
        if(password != confirmPassword) {
            return false
        }
        
        return true
    }
    
}
