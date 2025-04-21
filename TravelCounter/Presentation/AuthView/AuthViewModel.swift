//
//  AuthViewModel.swift
//  TravelCounter
//
//  Created by 仲野将馬 on 2025/01/29.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated = false
    @AppStorage("userId") var userId: Int = 0
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let signInWithEmailUseCase: SignInWithEmailUseCase
    private let signUpWithEmailUseCase: SignUpWithEmailUseCase
    private let signInWithGoogleUseCase: SignInWithGoogleUseCase
    private let signOutUseCase: SignOutUseCase
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    
    init(
        signInWithEmailUseCase: SignInWithEmailUseCase = SignInWithEmailUseCase(),
        signUpWithEmailUseCase: SignUpWithEmailUseCase = SignUpWithEmailUseCase(),
        signInWithGoogleUseCase: SignInWithGoogleUseCase = SignInWithGoogleUseCase(),
        signOutUseCase: SignOutUseCase = SignOutUseCase(),
        getCurrentUserUseCase: GetCurrentUserUseCase = GetCurrentUserUseCase()
    ) {
        self.signInWithEmailUseCase = signInWithEmailUseCase
        self.signUpWithEmailUseCase = signUpWithEmailUseCase
        self.signInWithGoogleUseCase = signInWithGoogleUseCase
        self.signOutUseCase = signOutUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
        
        // 既存の認証状態を確認
        Task {
            do {
                if let userId = try await getCurrentUserUseCase.execute() {
                    await MainActor.run {
                        self.userId = userId
                        self.isAuthenticated = true
                    }
                }
            } catch {
                print("現在のユーザー取得に失敗: \(error)")
            }
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        Task {
            do {
                let userId = try await signInWithEmailUseCase.execute(email: email, password: password)
                await MainActor.run {
                    self.userId = userId
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.showError = true
                    self.errorMessage = "サインインに失敗しました"
                }
            }
        }
    }
    
    func createAccount(email: String, password: String) {
        Task {
            do {
                let userId = try await signUpWithEmailUseCase.execute(email: email, password: password)
                await MainActor.run {
                    self.userId = userId
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.showError = true
                    self.errorMessage = "アカウント作成に失敗しました"
                }
            }
        }
    }
    
    func signInWithGoogle(presenting: Any) {
        Task {
            do {
                let userId = try await signInWithGoogleUseCase.execute(presenting: presenting)
                await MainActor.run {
                    self.userId = userId
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.showError = true
                    self.errorMessage = "Google認証に失敗しました"
                }
            }
        }
    }
    
    //TODO: ログアウト機能の実装
    func signOut() {
        do {
            try signOutUseCase.execute()
            isAuthenticated = false
            userId = 0
        } catch {
            print("ログアウトエラー: \(error.localizedDescription)")
        }
    }
}
