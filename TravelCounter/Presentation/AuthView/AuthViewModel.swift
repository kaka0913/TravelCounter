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

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
                return
            }
            self?.isAuthenticated = true
        }
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
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
                print("Google Sign-In error: \(error.localizedDescription)")
                self?.showError = true
                self?.errorMessage = error.localizedDescription
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
                    print("Firebase auth error: \(error.localizedDescription)")
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                }
            }
        }
    }
}
