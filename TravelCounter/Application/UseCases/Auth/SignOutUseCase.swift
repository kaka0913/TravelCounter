import Foundation

final class SignOutUseCase {
    private let firebaseAuthRepository: FirebaseAuthRepositoryProtocol
    
    init(firebaseAuthRepository: FirebaseAuthRepositoryProtocol = FirebaseAuthRepository.shared) {
        self.firebaseAuthRepository = firebaseAuthRepository
    }
    
    func execute() throws {
        try firebaseAuthRepository.signOut()
    }
} 