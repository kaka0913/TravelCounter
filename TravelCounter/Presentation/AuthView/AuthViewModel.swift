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
    @Published var showError = false
    @Published var errorMessage = ""
    
    init() {
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
            self?.isAuthenticated = true
        }
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = self?.localizedErrorMessage(error) ?? "エラーが発生しました"
                return
            }
            self?.isAuthenticated = true
        }
    }
    
    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
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
                
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    //TODO: ログアウト機能の実装
    func signOut() {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance.signOut()
            isAuthenticated = false
        } catch {
            print("ログアウトエラー: \(error.localizedDescription)")
        }
    }
}
