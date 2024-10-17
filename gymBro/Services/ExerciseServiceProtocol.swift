import FirebaseFirestore

protocol ExerciseServiceProtocol {
    func fetchAllExercices(idCategory: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void)
    
    func buildExercisesRequest(_ documents: [QueryDocumentSnapshot]) -> [ExerciseRequest]
    
    func buildExerciseInstanceById(_ document: DocumentSnapshot, _ exerciseId: String) -> ExerciseRequest
    
    func fetchExerciseById(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void)
    
    func registerNewExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping (ExerciseRequest?, Error?) -> Void)
    
    func editExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping(ExerciseRequest?, Error?) -> Void)
    
    func buildExerciseData(name: String, series: String, reps: Int, date: Date) -> [String: Any]
}
