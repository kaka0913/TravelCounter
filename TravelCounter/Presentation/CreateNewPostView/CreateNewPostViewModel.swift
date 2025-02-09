//
//  CreateNewPostViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI
import CoreLocation
import AMJpnMap

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
    @Published var isCreating = false
    @Published var isLoadingGroups = false
    @Published var userGroups: [UserGroup] = []
    
    @AppStorage("userId") private var userId: Int = 0
    
    private let createPostUseCase: CreatePostUseCase
    private let getUserGroupsUseCase: GetUserGroupsUseCase
    private let geocoder = CLGeocoder()
    
    init(
        createPostUseCase: CreatePostUseCase = CreatePostUseCase(),
        getUserGroupsUseCase: GetUserGroupsUseCase = GetUserGroupsUseCase()
    ) {
        self.createPostUseCase = createPostUseCase
        self.getUserGroupsUseCase = getUserGroupsUseCase
        fetchUserGroups()
    }
    
    private func fetchUserGroups() {
        isLoadingGroups = true
        
        Task {
            do {
                let groups = try await getUserGroupsUseCase.execute(userId: userId)
                await MainActor.run {
                    self.userGroups = groups
                    self.isLoadingGroups = false
                }
            } catch {
                await MainActor.run {
                    self.alertMessage = "グループの取得に失敗しました"
                    self.showingAlert = true
                    self.isLoadingGroups = false
                }
            }
        }
    }
    
    func toggleGroup(_ groupId: Int) {
        if selectedGroups.contains(groupId) {
            selectedGroups.remove(groupId)
        } else {
            selectedGroups.insert(groupId)
        }
    }
    
    private func convertImageToBase64(_ image: UIImage) -> String? {
        // 画像を圧縮してデータサイズを削減
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    private func getPrefectureId(from location: CLLocationCoordinate2D) async throws -> String {
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let prefecture = placemarks.first?.administrativeArea else {
            throw NSError(domain: "CreateNewPostViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "都道府県の取得に失敗しました"])
        }
        
        guard let prefecture = AMPrefecture.fromJapaneseName(prefecture) else {
            throw NSError(domain: "CreateNewPostViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "都道府県の変換に失敗しました"])
        }
        
        return prefecture.prefectureId
    }
    
    func createPost() async -> Bool {
        // バリデーション
        guard let image = image else {
            await MainActor.run {
                alertMessage = "画像を選択してください"
                showingAlert = true
            }
            return false
        }
        
        guard !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await MainActor.run {
                alertMessage = "コメントを入力してください"
                showingAlert = true
            }
            return false
        }
        
        guard let location = location else {
            await MainActor.run {
                alertMessage = "位置情報を設定してください"
                showingAlert = true
            }
            return false
        }
        
        guard selectedGroups.count > 0 else {
            await MainActor.run {
                alertMessage = "少なくとも1つのグループを選択してください"
                showingAlert = true
            }
            return false
        }
        
        guard let imageBase64 = convertImageToBase64(image) else {
            await MainActor.run {
                alertMessage = "画像の変換に失敗しました"
                showingAlert = true
            }
            return false
        }
        
        await MainActor.run {
            isCreating = true
        }
        
        do {
            let prefectureId = try await getPrefectureId(from: location)
            let success = try await createPostUseCase.execute(
                image: imageBase64,
                comment: comment,
                coordinate: location,
                userId: userId,
                prefectureId: prefectureId,
                groupIds: Array(selectedGroups)
            )
            
            await MainActor.run {
                isCreating = false
            }
            
            return success
        } catch {
            await MainActor.run {
                alertMessage = error.localizedDescription
                showingAlert = true
                isCreating = false
            }
            return false
        }
    }
}
