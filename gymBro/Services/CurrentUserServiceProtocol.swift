import Foundation

protocol CurrentUserService {
    var userId: String? { get }
    var email: String? { get }
    var displayName: String? { get }
    func isAuthenticated() -> Bool
    func getAuthenticatedUserId() -> Result<String, NSError>
}
