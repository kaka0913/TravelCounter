//
//  SigninUseCase.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/07.
//

import Foundation

final class SigninUseCase {
    private let repository: AuthRepositoryProtocol
    static let shared = SigninUseCase()
    
    init(repository: AuthRepositoryProtocol = AuthRepository.shared) {
        self.repository = repository
    }
    
    func execute(authId: String) async throws -> Int {
        return try await repository.signin(authId: authId)
    }
}
