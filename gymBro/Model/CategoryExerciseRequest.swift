//
//  ExerciceModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 26/07/24.
//

import Foundation

struct CategoryExerciseRequest {
    var id: String
    let categoryName:String
    let description: String?
    let weekDay: String?
    // let exercices: [ExerciseModel]
    // let typeIcon: String
    // let weekDay: String // This property is used for the user to register which day of the week the exercise will be performed, Example: Monday, Tuesday...
}
