//
//  CreateNewGroupViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/06.
//

import SwiftUI

class CreateNewGroupViewModel: ObservableObject {
    @Published var groupName: String = ""
    @Published var iconImage: UIImage?
    @Published var password: String = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showingImagePicker = false

    func createGroup() {
        // バリデーション
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
        
        guard iconImage != nil else {
            alertMessage = "アイコン画像を選択してください"
            showingAlert = true
            return
        }
        
        // TODO: グループの保存処理
        print("Group created with name: \(groupName), password: \(password)")
    }
}
