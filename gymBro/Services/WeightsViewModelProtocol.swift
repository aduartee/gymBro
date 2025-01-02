protocol WeightsViewModelProtocol {
    func getExerciseDataById(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void)
    func getWeightData(idCategory: String, exerciseId: String, completion: @escaping ([WeightsSection?], Error?) -> Void)
}
