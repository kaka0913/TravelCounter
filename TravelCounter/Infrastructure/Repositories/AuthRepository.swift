//
//  AuthRepository.swift
//  TravelCounter
//
//  Created by 仲野将馬 on 2025/02/07.
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
    
    func getProfile(userId: Int) async throws -> UserProfile {
        //TODO: APIを呼び出すようにして、後で消す
        #if DEBUG
        // 開発時はモックデータを使用
        return try await Self.getMockProfile(userId: userId)
        #else
        // 本番環境では実際のAPIを呼び出し
        let request = GetProfileRequest(userId: userId)
        let response = try await apiClient.call(request: request)
        return UserProfile(
            id: userId,
            name: response.userName,
            imageURL: URL(string: response.icon)
        )
        #endif
    }
}

// MARK: - Mock Data
extension AuthRepository {
    static func getMockProfile(userId: Int) async throws -> UserProfile {
        // 開発用の固定データを返す
        return UserProfile(
            id: userId,
            name: "テストユーザー",
            imageURL: URL(string: "https://example.com/test-user.jpg")
        )
    }
}
