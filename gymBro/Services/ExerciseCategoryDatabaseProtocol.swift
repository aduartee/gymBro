import Foundation
import Firebase

protocol ExerciseCategoryDatabaseService {
    func fetchCategoryDocument(userId: String, categoryId: String, completion: @escaping (Result<DocumentSnapshot, NSError>) -> Void)
}
