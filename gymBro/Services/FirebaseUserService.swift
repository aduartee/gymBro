import Foundation
import FirebaseAuth

class FirebaseUserService: CurrentUserService {
    static let shared = FirebaseUserService()
    
    private init() {}
    
    var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var email: String? {
        return Auth.auth().currentUser?.email
    }
    
    var displayName: String? {
        return Auth.auth().currentUser?.displayName
    }
    
    func isAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    /// Get the unwrapped userUID from current user, if the user was correct returns the correct valeu, else return a Error
    /// - Returns: UserID: String for sucess or NSError for fail
    func getAuthenticatedUserId() -> Result <String, NSError> {
        guard let userId = self.userId else {
            let error = ErrorUtil.createNSError(domain: "AuthError", description: "No current user")
            return .failure(error)
        }
        
        return .success(userId)
    }
}
