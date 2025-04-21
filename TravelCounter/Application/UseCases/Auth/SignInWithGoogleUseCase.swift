import Foundation

final class SignInWithGoogleUseCase {
    private let firebaseAuthRepository: FirebaseAuthRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    
    init(
        firebaseAuthRepository: FirebaseAuthRepositoryProtocol = FirebaseAuthRepository.shared,
        authRepository: AuthRepositoryProtocol = AuthRepository.shared
    ) {
        self.firebaseAuthRepository = firebaseAuthRepository
        self.authRepository = authRepository
    }
    
    func execute(presenting: Any) async throws -> Int {
        let authUser = try await firebaseAuthRepository.signInWithGoogle(presenting: presenting)
        if authUser.isNewUser {
            return try await authRepository.signup(
                userName: authUser.displayName ?? authUser.email ?? "Unknown",
                icon: authUser.photoURL ?? "",
                authId: authUser.authId
            )
        } else {
            return try await authRepository.signin(authId: authUser.authId)
        }
    }
} 