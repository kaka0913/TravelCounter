//
//  AuthViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated = false
    @AppStorage("userId") var userId: Int = 0
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let signinUseCase: SigninUseCase
    private let signupUseCase: SignupUseCase
    
    init(
        signinUseCase: SigninUseCase = SigninUseCase.shared,
        signupUseCase: SignupUseCase = SignupUseCase.shared
    ) {
        self.signinUseCase = signinUseCase
        self.signupUseCase = signupUseCase
        // 既存の認証状態を確認
        isAuthenticated = Auth.auth().currentUser != nil
    }
    
    private func localizedErrorMessage(_ error: Error) -> String {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.invalidEmail.rawValue:
            return "メールアドレスの形式が正しくありません"
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "このメールアドレスは既に使用されています"
        case AuthErrorCode.weakPassword.rawValue:
            return "パスワードは6文字以上で設定してください"
        case AuthErrorCode.wrongPassword.rawValue:
            return "パスワードが間違っています"
        case AuthErrorCode.userNotFound.rawValue:
            return "アカウントが見つかりません"
        case AuthErrorCode.networkError.rawValue:
            return "ネットワークエラーが発生しました"
        case AuthErrorCode.tooManyRequests.rawValue:
            return "試行回数が多すぎます。しばらく時間をおいて再度お試しください"
        default:
            return "エラーが発生しました。もう一度お試しください"
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = self?.localizedErrorMessage(error) ?? "エラーが発生しました"
                return
            }
            
            Task {
                do {
                    if let user = result?.user {
                        let userId = try await self?.signinUseCase.execute(authId: user.uid)
                        await MainActor.run {
                            if let userId = userId {
                                self?.userId = userId
                            }
                            self?.isAuthenticated = true
                        }
                    }
                } catch {
                    await MainActor.run {
                        self?.showError = true
                        self?.errorMessage = "サインインに失敗しました"
                    }
                }
            }
        }
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = self?.localizedErrorMessage(error) ?? "エラーが発生しました"
                return
            }
            
            Task {
                do {
                    if let user = result?.user {
                        // TODO: アイコン画像の処理を実装
                        let userId = try await self?.signupUseCase.execute(
                            userName: user.email ?? "Unknown",
                            icon: "",
                            authId: user.uid
                        )
                        await MainActor.run {
                            if let userId = userId {
                                self?.userId = userId
                            }
                            self?.isAuthenticated = true
                        }
                    }
                } catch {
                    await MainActor.run {
                        self?.showError = true
                        self?.errorMessage = "アカウント作成に失敗しました"
                    }
                }
            }
        }
    }
    
    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if error != nil {
                self?.showError = true
                self?.errorMessage = "Googleログインに失敗しました"
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.showError = true
                self?.errorMessage = "Google認証に失敗しました"
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            // Firebase認証を実行
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.showError = true
                    self?.errorMessage = self?.localizedErrorMessage(error) ?? "認証に失敗しました"
                    return
                }
                
                Task {
                    do {
                        if let firebaseUser = authResult?.user {
                            var userId: Int?
                            // Googleアカウントでの初回サインインの場合はサインアップを実行
                            if authResult?.additionalUserInfo?.isNewUser == true {
                                userId = try await self?.signupUseCase.execute(
                                    userName: firebaseUser.displayName ?? "Unknown",
                                    icon: firebaseUser.photoURL?.absoluteString ?? "",
                                    authId: firebaseUser.uid
                                )
                            } else {
                                userId = try await self?.signinUseCase.execute(authId: firebaseUser.uid)
                            }
                            
                            await MainActor.run {
                                if let userId = userId {
                                    self?.userId = userId
                                }
                                self?.isAuthenticated = true
                            }
                        }
                    } catch {
                        await MainActor.run {
                            self?.showError = true
                            self?.errorMessage = "認証に失敗しました"
                        }
                    }
                }
            }
        }
    }
    
    //TODO: ログアウト機能の実装
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            isAuthenticated = false
            userId = 0  // ユーザーIDをリセット
        } catch {
            print("ログアウトエラー: \(error.localizedDescription)")
        }
    }
}
