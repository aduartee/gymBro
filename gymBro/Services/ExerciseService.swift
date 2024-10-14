import FirebaseStorage
import Foundation

class ExerciseService: ExerciseServiceProtocol {
    public static let shared = ExerciseService()
    private let databaseService: ExerciseServiceProtocol
    private var userId: String? {
        switch FirebaseUserService.shared.getAuthenticatedUserId() {
        case .success(let userUId):
            return userUId
            
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    private init(databaseService: ExerciseServiceProtocol = FirestoreExerciseService) {
        self.databaseService = databaseService
    }

    public func fetchAllExercices(idCategory: String, completion: @escaping ([ExerciseRequest]?, Error?) -> Void) {
        guard let userUid = self.userId else {
            completion(nil, ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        self.databaseService.fetchExerciseDocument(idCategory: String, userId: String) { exerciseDocuments in
            switch exerciseDocuments {
            case .failure(let error) {
                completion(nil, error)
            }
                
            case .success(let documents)
                let exercisesData = self.buildExercisesRequest(documents)
                completion(exerciseDocuments, nil)
            }
        }
    }
    
    private func buildExercisesRequest(_ documents: [QueryDocumentSnapshot]) -> [ExerciseRequest] {
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
    
    private func buildExerciseById(_ document: DocumentSnapshot) -> ExerciseRequest {
        return ExerciseRequest(
            id: exerciseId,
            name: data["name"] as? String ?? "",
            series: data["series"] as? String ?? "",
            repetitions: data["repetitions"] as? Int ?? 1,
            date: data["date"] as? Date ?? Date()
        )
    }
    
    private func buildExerciseData(name: String, series: String, reps: Int, date: Date) -> [String: Any] {
        let exerciseData: [String: Any] = [
            "name": exerciseName,
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
                let exerciseData = buildExerciseById(document)
                completion(exerciseData, nil)
            }
        }
    }
    
    public func registerNewExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil,  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let exerciseData = buildExerciseData(name: exerciseRequest.name,
                                             series: exerciseRequest.series,
                                             reps: exerciseRequest.repetitions,
                                             date: exerciseRequest.date
        )
        
        let exerciseCollection = self.fetchExerciseCollection(idCategory: categoryId, userId: userId)
        
        switch databaseService.registerExerciseFirabase(exerciseData: exerciseData, exerciseCollection: exerciseCollection) {
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
    
    public func editExercise(categoryId: String, exerciseRequest: ExerciseRequest, completion: @escaping(ExerciseRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil,  ErrorUtil.createNSError(domain: "AuthError", description: "No current user"))
            return
        }
        
        let exerciseId = exerciseRequest.id
        let exerciseDocument = self.databaseService.fetchExerciseDocumentById(idCategory: categoryId, exerciseId: exerciseId, userId: userId) { exerciseDocument in
            
            switch exerciseDocument {
            case .failure(let error):
                completion(nil, error)
                
            case .success(let document):
                let exerciseData = self.buildExerciseData(name: exerciseRequest.name,
                                                          series: exerciseRequest.series,
                                                          reps: exerciseRequest.repetitions,
                                                          date: exerciseRequest.date)
                
                databaseService.editExerciseFirebase(exerciseEditedData: exerciseData, exerciseDocument: document) { operationStatus in
                    switch operationStatus {
                    case .failure(let error):
                        completion(nil, error)
                        
                    case .success():
                        completion(exerciseRequest, nil)
                    }
                }
            }
        }
    }
}
