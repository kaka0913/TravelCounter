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
        VStack(spacing: 10) {
            Text("新規グループ作成")
                .font(.title3)
                .bold()
                .padding(.vertical)
                
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let image = viewModel.groupImage {
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
                                        Image(systemName: "person.3.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            Button(action: {
                                viewModel.showingImagePicker = true
                            }) {
                                Text(viewModel.groupImage == nil ? "画像を選択" : "画像を変更")
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    TextField("グループ名", text: $viewModel.groupName)
                    SecureField("パスワード", text: $viewModel.password)
                }
                
                Section {
                    Button(action: {
                        Task {
                            await viewModel.createGroup()
                        }
                    }) {
                        if viewModel.isCreating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("グループを作成")
                        }
                    }
                    .disabled(viewModel.isCreating)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.groupImage)
        }
        .alert("エラー", isPresented: $viewModel.showError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
