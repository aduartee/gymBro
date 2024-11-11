protocol WeightsViewModelProtocol {
    func getExerciseData(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void)
}
