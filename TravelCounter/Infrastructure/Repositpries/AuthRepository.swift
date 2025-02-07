//
//  AuthRepository.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/07.
//

import Foundation

class AuthRepository: AuthRepositoryProtocol {
    private let apiClient = APIClient.shared
    static let shared = AuthRepository()
    
    func signup(userName: String, icon: String, authId: String) async throws -> Int {
        let request = SignupRequest(userName: userName, icon: icon, authId: authId)
        let response = try await apiClient.call(request: request)
        return response.userId
    }
    
    func signin(authId: String) async throws -> Int {
        let request = SigninRequest(authId: authId)
        let response = try await apiClient.call(request: request)
        return response.userId
    }
    
    func getProfile(userId: Int) async throws -> Profile {
        let request = GetProfileRequest(userId: userId)
        let response = try await apiClient.call(request: request)
        return Profile(
            userName: response.userName,
            icon: response.icon,
            createdAt: response.createdAt,
            updatedAt: response.updatedAt
        )
    }
}
