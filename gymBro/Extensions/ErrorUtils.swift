import Foundation

class ErrorUtil {
    static func createNSError(domain: String, description: String) -> NSError {
        return NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
