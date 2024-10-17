import Foundation
import FirebaseFirestore
import FirebaseAuth

class ExerciseCategoryService:ExerciseCatergoryServiceProtocol {
    public static let shared = ExerciseCategoryService()
    private let dataBaseService: ExerciseCategoryDatabaseService
    private var userId: String? {
        switch FirebaseUserService.shared.getAuthenticatedUserId() {
        case .success(let userUId):
            return userUId
            
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    init(dataBaseService: ExerciseCategoryDatabaseService = FirestoreExerciseCategoryService()) {
        self.dataBaseService = dataBaseService
    }
    
    public func fetchExerciseCategoryById(categoryId: String, completion: @escaping (CategoryExerciseRequest?, Error?) -> Void) {
        guard let userId = self.userId else {
            completion(nil, ErrorUtil.createNSError(domain: "ExerciseServiceError", description: "User ID is missing."))
            return
        }

        dataBaseService.fetchCategoryDocument(userId: userId, categoryId: categoryId) { document in
            switch document {

            case .success(let document) :
                let categoryExerciseData: CategoryExerciseRequest = self.buildCategoryExerciseRequest(data: document, categoryId: categoryId)
                completion(categoryExerciseData, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    internal func buildCategoryExerciseRequest(data: DocumentSnapshot, categoryId: String) -> CategoryExerciseRequest {
        return CategoryExerciseRequest(
            id: categoryId,
            categoryName: data["name"] as? String ?? "",
            description: data["description"] as? String ?? "",
            weekDay: data["weekDay"] as? String ?? ""
        )
    }
}
