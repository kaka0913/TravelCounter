import Foundation

final class SignInWithEmailUseCase {
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
        let authUser = try await firebaseAuthRepository.signInWithEmail(email: email, password: password)
        return try await authRepository.signin(authId: authUser.authId)
    }
} 