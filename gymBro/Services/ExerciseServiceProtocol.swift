import FirebaseFirestore

protocol ExerciseServiceProtocol {
    func fetchAllExercices(idCategory: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void)
    
    func buildExercisesRequest(documents: [QueryDocumentSnapshot]) -> [ExerciseRequest]
    
    func buildExerciseById(_ document: DocumentSnapshot) -> ExerciseRequest
    
    func fetchExerciseById(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void)
    
    func registerNewExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping (ExerciseRequest?, Error?) -> Void)
    
    func editExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping(ExerciseRequest?, Error?) -> Void)
    
    func buildExerciseData(name: String, series: String, reps: Int, date: Date) -> [String: Any]
}
