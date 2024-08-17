//
//  HomeViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 23/07/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct HomeViewModel {
    public func getUsernameCurretUser(completion: @escaping (String?, Error?) -> Void) {
        HomeService.shared.getUsernameCurrentUser { username, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let username = username else {
                completion(nil, error)
                return
            }
            
            completion(username, nil)
        }
    }
    
    public func getAllCategoryExercices(completion: @escaping ([CategoryExerciseRequest]? , Error?) -> Void) {
        HomeService.shared.getTypeExercicesByCurrentUser { categoryName, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let categoryName = categoryName else {
                completion(nil, error)
                return
            }
            
            completion(categoryName, nil)
        }
    }
    
    public func removeSelectedRow(categoryExerciseId: String, completion: @escaping (Error?) -> Void) {
        HomeService.shared.deleteExerciseCategory(categoryExerciceId: categoryExerciseId) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
