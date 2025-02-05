//
//  CreateNewGroupViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/06.
//

import SwiftUI

class CreateNewGroupViewModel: ObservableObject {
    @Published var groupName: String = ""
    @Published var selectedImage: UIImage?
    @Published var password: String = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showingImagePicker = false
    @Published var isLoading = false

    func createGroup() {
        guard !groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "グループ名を入力してください"
            showingAlert = true
            return
        }
        
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "パスワードを入力してください"
            showingAlert = true
            return
        }
        
        guard selectedImage != nil else {
            alertMessage = "グループ画像を選択してください"
            showingAlert = true
            return
        }

        isLoading = true
        
        Task {
            do {
                if let image = selectedImage {
                    // TODO: グループの保存処理
                    print("Group created with name: \(groupName), password: \(password)")
                }
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "グループの作成に失敗しました"
                    showingAlert = true
                }
            }
        }
    }
}
