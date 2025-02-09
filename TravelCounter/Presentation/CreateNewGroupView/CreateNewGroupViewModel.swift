//
//  CreateNewGroupViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/06.
//

import SwiftUI
import Foundation

extension Notification.Name {
    static let groupCreated = Notification.Name("groupCreated")
}

class CreateNewGroupViewModel: ObservableObject {
    @Published var groupName: String = ""
    @Published var password: String = ""
    @Published var groupImage: UIImage?
    @Published var isCreating = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showingImagePicker = false
    
    func createGroup() async {
        guard !groupName.isEmpty else {
            showError = true
            errorMessage = "グループ名を入力してください"
            return
        }
        
        guard let _ = groupImage else {
            showError = true
            errorMessage = "グループ画像を選択してください"
            return
        }
        
        guard !password.isEmpty else {
            showError = true
            errorMessage = "パスワードを入力してください"
            return
        }
        
        await MainActor.run {
            isCreating = true
        }
        
        // TODO: 実際のAPI呼び出しに置き換える
        // 開発用のモックデータ
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            isCreating = false
            // TODO: グループ作成成功時の処理
            NotificationCenter.default.post(name: .groupCreated, object: nil)
        }
    }
}
