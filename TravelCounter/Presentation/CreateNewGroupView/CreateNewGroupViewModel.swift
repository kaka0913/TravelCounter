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

@MainActor
class CreateNewGroupViewModel: ObservableObject {
    @Published var groupName: String = ""
    @Published var password: String = ""
    @Published var groupImage: UIImage?
    @Published var isCreating = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showingImagePicker = false
    
    @AppStorage("userId") private var userId: Int = 0
    private let createGroupUseCase: CreateGroupUseCase
    
    init(createGroupUseCase: CreateGroupUseCase = CreateGroupUseCase()) {
        self.createGroupUseCase = createGroupUseCase
    }
    
    private func convertImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    func createGroup() async {
        guard !groupName.isEmpty else {
            showError = true
            errorMessage = "グループ名を入力してください"
            return
        }
        
        guard let image = groupImage else {
            showError = true
            errorMessage = "グループ画像を選択してください"
            return
        }
        
        guard !password.isEmpty else {
            showError = true
            errorMessage = "パスワードを入力してください"
            return
        }
        
        guard let imageBase64 = convertImageToBase64(image) else {
            showError = true
            errorMessage = "画像の変換に失敗しました"
            return
        }
        
        isCreating = true
        
        do {
            let groupId = try await createGroupUseCase.execute(
                name: groupName,
                icon: imageBase64,
                password: password,
                authorId: userId
            )
            
            // グループ作成成功時の処理
            NotificationCenter.default.post(
                name: .groupCreated,
                object: nil,
                userInfo: ["groupId": groupId]
            )
            
            isCreating = false
        } catch {
            showError = true
            errorMessage = "グループの作成に失敗しました"
            isCreating = false
        }
    }
}
