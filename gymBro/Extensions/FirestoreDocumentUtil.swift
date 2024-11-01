import Firebase

class FirestoreDocumentUtil {
    
    /// Validates if a document exists in Firebase. This function returns the data of the document and is used to retrieve a single document from Firebase.
    /// - Parameter document: The document to validate.
    /// - Returns: A Result containing either a success with the document if it exists, or a failure with an error if the document is nil or doesen't exist..
    static func isDocumentExistData(_ document: DocumentSnapshot?) -> Result<DocumentSnapshot, NSError> {
        guard let document = document, document.exists, let _ = document.data() else {
            let documentError = ErrorUtil.createNSError(domain: "FirebaseError", description: "Exercise does not exist, register a new exercise and try again")
            return .failure(documentError)
        }
        
        return .success(document)
    }
    
    
    static func isDocumentExistDocuments(_ querySnapshot: QuerySnapshot?) -> Result<[QueryDocumentSnapshot], NSError> {
        guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
            let documentError = ErrorUtil.createNSError(domain: "FirebaseError", description: "Exercise Series does not exist yet, register a new serie and try again")
            return .failure(documentError)
        }
        
        return .success(querySnapshot.documents)
    }
}
