//
//  AuthRepositoryProtocol.swift
//  TravelCounter
//
//  Created by 仲野将馬 on 2025/02/07.
//

import Foundation

protocol AuthRepositoryProtocol {
    func signup(userName: String, icon: String, authId: String) async throws -> Int
    func signin(authId: String) async throws -> Int
    func getProfile(userId: Int) async throws -> UserProfile
}
