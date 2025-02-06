//
//  ProfileSettingView.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI
import PhotosUI

struct ProfileSettingView: View {
    @StateObject private var viewModel = ProfileSettingViewModel()
    let onComplete: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let profileImage = viewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            }
                            
                            Button("画像を変更") {
                                viewModel.isImagePickerPresented = true
                            }
                            .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 16)
                }
                
                Section(header: Text("プロフィール情報")) {
                    TextField("ユーザーネーム", text: $viewModel.userName)
                        .textContentType(.username)
                }
                
                Button("完了") {
                    viewModel.saveProfile()
                    onComplete()
                }
                .disabled(viewModel.userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("プロフィール設定")
            .sheet(isPresented: $viewModel.isImagePickerPresented) {
                ImagePicker(image: $viewModel.profileImage)
            }
            .alert("エラー", isPresented: $viewModel.showingAlert) {
                Button("OK") {}
            } message: {
                Text(viewModel.alertMessage)
            }
            .onAppear {
                viewModel.loadProfile()
            }
        }
    }
}
