import Foundation

final class SignUpWithEmailUseCase {
    private let firebaseAuthRepository: FirebaseAuthRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    
    init(
        firebaseAuthRepository: FirebaseAuthRepositoryProtocol = FirebaseAuthRepository.shared,
        authRepository: AuthRepositoryProtocol = AuthRepository.shared
    ) {
        self.firebaseAuthRepository = firebaseAuthRepository
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async throws -> Int {
        let authUser = try await firebaseAuthRepository.createAccount(email: email, password: password)
        return try await authRepository.signup(
            userName: authUser.email ?? "Unknown",
            icon: authUser.photoURL ?? "",
            authId: authUser.authId
        )
    }
} 