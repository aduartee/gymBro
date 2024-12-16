import Foundation
import Firebase

class ExerciseService: ExerciseServiceProtocol {
    public static let shared = ExerciseService()
    private let databaseService: ExerciseDatabaseServiceProtocol
    private var userId: String? {
        switch FirebaseUserService.shared.getAuthenticatedUserId() {
        case .success(let userUId):
            return userUId
            
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    private init(databaseService: ExerciseDatabaseServiceProtocol = FirestoreExerciseService()) {
        self.databaseService = databaseService
    }

    public func fetchAllExercices(idCategory: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void) {
        guard let userUid = self.userId else {
            completion(nil, ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        self.databaseService.fetchExerciseDocument(idCategory: idCategory, userId: userUid) { exerciseDocuments in
            switch exerciseDocuments {
            case .failure(let error):
                completion(nil, error)
                return
                
            case .success(let documents):
                let exercisesData = self.buildExercisesRequest(documents)
                completion(exercisesData, nil)
                return
            }
        }
    }
    
    internal func buildExercisesRequest(_ documents: [QueryDocumentSnapshot]) -> [ExerciseRequest] {
        var exercisesModel: [ExerciseRequest] = []
        
        for document in documents {
            let data = document.data()
            let id = document.documentID
            let name: String = data["name"] as? String ?? ""
            let series: String = data["series"] as? String ?? ""
            let repetitions: Int = data["repetitions"] as? Int ?? 0
            let date: Date = data["date"] as? Date ?? Date()
            let exerciseInstance = ExerciseRequest(id: id, name: name, series: series, repetitions: repetitions, date: date)
            exercisesModel.append(exerciseInstance)
        }
        
        return exercisesModel
    }
    
    internal func buildExerciseInstanceById(_ document: DocumentSnapshot, _ exerciseId: String) -> ExerciseRequest {
        return ExerciseRequest(
            id: exerciseId,
            name: document["name"] as? String ?? "",
            series: document["series"] as? String ?? "",
            repetitions: document["repetitions"] as? Int ?? 1,
            date: document["date"] as? Date ?? Date()
        )
    }
    
    internal func buildExerciseData(name: String, series: String, reps: Int, date: Date) -> [String: Any] {
        let exerciseData: [String: Any] = [
            "name": name,
            "series": series,
            "repetitions" : reps,
            "date" : date
        ]
        
        return exerciseData
    }
    
    public func fetchExerciseById(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil,  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        self.databaseService.fetchExerciseDocumentById(idCategory: idCategory, exerciseId: exerciseId, userId: userId) { exerciseDocument in
            switch exerciseDocument {
            case .failure(let error):
                completion(nil, error)
                
            case .success(let document):
                let exerciseData = self.buildExerciseInstanceById(document, exerciseId)
                completion(exerciseData, nil)
            }
        }
    }
    
    func registerNewExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil,  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let exerciseData = buildExerciseData(name: exerciseRequest.name,
                                             series: exerciseRequest.series,
                                             reps: exerciseRequest.repetitions,
                                             date: exerciseRequest.date
        )
        
        let exerciseCollection = databaseService.fetchExerciseCollection(idCategory: categoryId, userId: userId)
        
        databaseService.registerExerciseFirabase(exerciseData: exerciseData, exerciseCollection: exerciseCollection) { referenceDocumentExercise in
        
            switch referenceDocumentExercise {
            case .failure(let error):
                completion(nil, error)
                
            case .success(let documentReference):
                let exerciseInstance = ExerciseRequest(
                    id: documentReference.documentID,
                    name: exerciseRequest.name,
                    series: exerciseRequest.series,
                    repetitions: exerciseRequest.repetitions,
                    date: exerciseRequest.date
                )
                
                completion(exerciseInstance, nil)
            }
        }
    }
    
    func editExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping(ExerciseRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil,  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let exerciseId = exerciseRequest.id
        let exerciseReference = self.databaseService.fetchExerciseReferenceById(idCategory: categoryId, exerciseId: exerciseId, userId: userId)
        let exerciseData = self.buildExerciseData(name: exerciseRequest.name,
                                                  series: exerciseRequest.series,
                                                  reps: exerciseRequest.repetitions,
                                                  date: exerciseRequest.date)
        
        databaseService.editExerciseFirebase(exerciseEditedData: exerciseData, exerciseDocument: exerciseReference) { operationStatus in
            switch operationStatus {
            case .failure(let error):
                completion(nil, error)
                
            case .success( _):
                completion(exerciseRequest, nil)
            }
        }
    }
}

