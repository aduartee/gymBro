enum ExerciseErrorEnum: Error {
    case invalidName
    case invalidReps
    case invalidWeight
    case exerciseNotFound
    case errorEdit
    case errorRegister
    
    var localizedDescription: String {
        switch self {
        case .invalidName:
            return "The exercise name is invalid."
        case .invalidReps:
            return "The number of reps is invalid."
        case .invalidWeight:
            return "The weight entered is invalid."
        case .exerciseNotFound:
            return "The exercise could not be found."
        case .errorEdit:
            return "The exercise could not be edited."
        case .errorRegister:
            return "The exercise could not be edited."
        }
    }
}
