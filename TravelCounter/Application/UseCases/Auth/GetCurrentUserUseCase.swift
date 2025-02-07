import Foundation

final class GetCurrentUserUseCase {
    private let firebaseAuthRepository: FirebaseAuthRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    
    init(
        firebaseAuthRepository: FirebaseAuthRepositoryProtocol = FirebaseAuthRepository.shared,
        authRepository: AuthRepositoryProtocol = AuthRepository.shared
    ) {
        self.firebaseAuthRepository = firebaseAuthRepository
        self.authRepository = authRepository
    }
    
    func execute() async throws -> Int? {
        guard let authUser = firebaseAuthRepository.getCurrentUser() else { return nil }
        return try await authRepository.signin(authId: authUser.authId)
    }
} 