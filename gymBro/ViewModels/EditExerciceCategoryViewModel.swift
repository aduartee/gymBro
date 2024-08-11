//
//  EditExerciceCategoryViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 10/08/24.
//

import Foundation

struct EditExerciceCategoryViewModel {
    let id: String
    let categoryName: String
    let description: String?
    let weekDay: String?
    
    func getDataExerciceCategory(idExerciceCategory: String) {
        HomeService.shared.getExerciceCategoryById(categoryExerciceId: idExerciceCategory) { categoryExercice, error in
            
        }
    }
}
