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
                
                Section(header: Text("アイコン")) {
                    HStack {
                        Spacer()
                        VStack {
                            if let image = viewModel.iconImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            Button(action: {
                                viewModel.showingImagePicker = true
                            }) {
                                Text(viewModel.iconImage == nil ? "画像を選択" : "画像を変更")
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
                }
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.iconImage)
            }
            .alert("エラー", isPresented: $viewModel.showingAlert) {
                Button("OK") {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}
