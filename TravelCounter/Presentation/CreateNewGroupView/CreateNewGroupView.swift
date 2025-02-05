//
//  CreateNewGroupView.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/06.
//

import SwiftUI

struct CreateNewGroupView: View {
    @StateObject private var viewModel = CreateNewGroupViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("グループ情報")) {
                    TextField("グループ名", text: $viewModel.groupName)
                        .textContentType(.organizationName)
                    
                    SecureField("パスワード", text: $viewModel.password)
                        .textContentType(.newPassword)
                }
                
                Section(header: Text("グループ画像")) {
                    HStack {
                        Spacer()
                        VStack {
                            if let image = viewModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 200, height: 200)
                                    .overlay(
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            Button(action: {
                                viewModel.showingImagePicker = true
                            }) {
                                Text(viewModel.selectedImage == nil ? "画像を選択" : "画像を変更")
                                    .padding(.top, 8)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("グループ作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("作成") {
                        viewModel.createGroup()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("作成中...")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                }
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
            .alert("エラー", isPresented: $viewModel.showingAlert) {
                Button("OK") {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}
