import Foundation

protocol FirebaseAuthRepositoryProtocol {
    func signInWithEmail(email: String, password: String) async throws -> AuthUser
    func createAccount(email: String, password: String) async throws -> AuthUser
    func signInWithGoogle(presenting: Any) async throws -> AuthUser
    func signOut() throws
    func getCurrentUser() -> AuthUser?
}