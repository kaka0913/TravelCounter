//
//  AuthView.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Image("Painteer")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.top, -20)
            
            Text("Painteer")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("旅の思い出を共有しよう")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // メール・パスワード入力フォーム
            VStack(spacing: 20) {
                TextField("メールアドレス", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                
                SecureField("パスワード", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
            }
            .padding(.horizontal)
            
            // ログインボタン
            Button(action: {
                viewModel.signInWithEmail(email: email, password: password)
            }) {
                Text("ログイン")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // アカウント作成ボタン
            Button(action: {
                viewModel.createAccount(email: email, password: password)
            }) {
                Text("アカウントを作成")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // 区切り線
            HStack {
                Rectangle()
                    .frame(height: 1)
                Text("または")
                Rectangle()
                    .frame(height: 1)
            }
            .foregroundColor(.gray)
            .padding()
            
            // Googleログインボタン
            GoogleSignInButton(action: viewModel.signInWithGoogle)
                .padding(.horizontal, 20)
        }
        .padding()
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("エラー"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
