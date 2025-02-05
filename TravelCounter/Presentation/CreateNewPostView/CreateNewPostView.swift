//
//  CreateNewPostView.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI
import MapKit

struct CreateNewPostView: View {
    @StateObject private var viewModel = CreateNewPostViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(8)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                    .frame(height: 200)
                            }
                            
                            Button(action: {
                                viewModel.showingImagePicker = true
                            }) {
                                Text(viewModel.image == nil ? "画像を選択" : "画像を変更")
                            }
                            .padding(.top, 8)
                        }
                        Spacer()
                    }
                }
                
                // コメント入力セクション
                Section(header: Text("コメント")) {
                    TextEditor(text: $viewModel.comment)
                        .frame(height: 50)
                }
                
                // 位置情報セクション
                Section(header: Text("位置情報")) {
                    if let locationName = viewModel.locationName {
                        Text(locationName)
                            .font(.body)
                    }
                    
                    Button(action: {
                        viewModel.showingLocationSearch = true
                    }) {
                        Text(viewModel.locationName == nil ? "位置情報を設定" : "位置情報を変更")
                    }
                }
                
                // グループ選択セクション
                Section(header: Text("共有するグループ")) {
                    ForEach(viewModel.userGroups) { group in
                        Button(action: {
                            viewModel.toggleGroup(group.id)
                        }) {
                            HStack {
                                Image(systemName: group.iconName)
                                    .foregroundColor(.primary)
                                Text(group.name)
                                Spacer()
                                if viewModel.selectedGroups.contains(group.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("新規投稿")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("投稿") {
                        viewModel.createPost()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.image)
            }
            .sheet(isPresented: $viewModel.showingLocationSearch) {
                LocationSearchView { coordinate, name in
                    viewModel.location = coordinate
                    viewModel.locationName = name
                }
            }
            .alert("エラー", isPresented: $viewModel.showingAlert) {
                Button("OK") {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}
