import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase

class FirebaseAuthRepository: FirebaseAuthRepositoryProtocol {
    static let shared = FirebaseAuthRepository()
    
    func signInWithEmail(email: String, password: String) async throws -> AuthUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthUser(
            authId: result.user.uid,
            email: result.user.email,
            displayName: result.user.displayName,
            photoURL: result.user.photoURL?.absoluteString,
            isNewUser: false
        )
    }
    
    func createAccount(email: String, password: String) async throws -> AuthUser {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthUser(
            authId: result.user.uid,
            email: result.user.email,
            displayName: result.user.displayName,
            photoURL: result.user.photoURL?.absoluteString,
            isNewUser: true
        )
    }
    
    func signInWithGoogle(presenting: Any) async throws -> AuthUser {
        guard let viewController = presenting as? UIViewController else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid presenting view controller"])
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        return AuthUser(
            authId: authResult.user.uid,
            email: authResult.user.email,
            displayName: authResult.user.displayName,
            photoURL: authResult.user.photoURL?.absoluteString,
            isNewUser: authResult.additionalUserInfo?.isNewUser ?? false
        )
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        try GIDSignIn.sharedInstance.signOut()
    }
    
    func getCurrentUser() -> AuthUser? {
        guard let user = Auth.auth().currentUser else { return nil }
        return AuthUser(
            authId: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL?.absoluteString,
            isNewUser: false
        )
    }
}
