import FirebaseFirestore

protocol ExerciseCatergoryServiceProtocol {
    func fetchExerciseCategoryById(categoryId: String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void)
    
    func buildCategoryExerciseRequest(data: DocumentSnapshot, categoryId: String) -> CategoryExerciseRequest
}

