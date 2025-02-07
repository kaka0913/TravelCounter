import Foundation

final class SignupUseCase {
    private let repository: AuthRepositoryProtocol
    static let shared = SignupUseCase()
    
    init(repository: AuthRepositoryProtocol = AuthRepository.shared) {
        self.repository = repository
    }
    
    func execute(userName: String, icon: String, authId: String) async throws -> Int {
        return try await repository.signup(userName: userName, icon: icon, authId: authId)
    }
}
