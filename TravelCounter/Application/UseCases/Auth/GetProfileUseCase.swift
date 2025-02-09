import Foundation

final class GetProfileUseCase {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository.shared) {
        self.authRepository = authRepository
    }
    
    func execute(userId: Int) async throws -> UserProfile {
        return try await authRepository.getProfile(userId: userId)
    }
} 