//
//  ProfileSettingViewModel.swift
//  TravelCounter
//
//  Created by 仲野将馬 on 2025/02/05.
//

import SwiftUI

class ProfileSettingViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var profileImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    func saveProfile() {
        // ユーザー名が空の場合は保存しない
        guard !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "ユーザー名を入力してください"
            showingAlert = true
            return
        }
        
        // TODO: プロフィール情報の保存処理
        // UserDefaultsやデータベースへの保存処理を実装
    }
}
