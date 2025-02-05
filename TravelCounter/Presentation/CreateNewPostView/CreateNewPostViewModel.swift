//
//  CreateNewPostViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI
import CoreLocation

class CreateNewPostViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var comment: String = ""
    @Published var selectedGroups: Set<Int> = []
    @Published var showingImagePicker = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var location: CLLocationCoordinate2D?
    @Published var locationName: String?
    @Published var selectedPrefectureId: Int?
    @Published var showingLocationSearch = false
    
    private(set) var currentUserId: Int
    private(set) var userGroups: [UserGroup]
    
    init() {
        // 現在のユーザーのデータを取得
        let currentUser = UserProfile(id: 0, name: "現在のユーザー", imageURL: nil)
        self.currentUserId = currentUser.id
        
        // ユーザーが所属しているグループを取得
        self.userGroups = [
            UserGroup(
                id: 1,
                name: "家族",
                imageURL: "house.fill",
                users: [
                    UserProfile(id: 1, name: "父", imageURL: nil),
                    UserProfile(id: 2, name: "母", imageURL: nil),
                    UserProfile(id: 3, name: "兄", imageURL: nil)
                ],
                password: "family2024"
            ),
            UserGroup(
                id: 2,
                name: "友達",
                imageURL: "person.2.fill",
                users: [
                    UserProfile(id: 4, name: "友達A", imageURL: nil),
                    UserProfile(id: 5, name: "友達B", imageURL: nil)
                ],
                password: "friends2024"
            )
        ]
    }
    
    func toggleGroup(_ groupId: Int) {
        if selectedGroups.contains(groupId) {
            selectedGroups.remove(groupId)
        } else {
            selectedGroups.insert(groupId)
        }
    }
    
    func createPost() {
        // バリデーション
        guard let _ = image else {
            alertMessage = "画像を選択してください"
            showingAlert = true
            return
        }
        
        guard !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "コメントを入力してください"
            showingAlert = true
            return
        }
        
        guard let _ = location else {
            alertMessage = "位置情報を設定してください"
            showingAlert = true
            return
        }
        
        guard selectedGroups.count > 0 else {
            alertMessage = "少なくとも1つのグループを選択してください"
            showingAlert = true
            return
        }
        
        // TODO: 投稿の保存処理
        print("Post created")
    }
}
