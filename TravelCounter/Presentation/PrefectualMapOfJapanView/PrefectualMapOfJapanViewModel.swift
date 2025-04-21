import Foundation
import AMJpnMap
import UIKit
import SwiftUI

class PrefectualMapOfJapanViewModel: ObservableObject {
    @Published var selectedRegion: AMRegion?
    @Published var selectedPrefecture: AMPrefecture?
    @Published var isShowingDetailMap: Bool = false
    @Published var currentUser: UserProfile?
    @Published var userGroups: [UserGroup] = []
    @Published var selectedGroup: UserGroup?
    @Published var selectedGroupMember: UserProfile?
    @Published var userProfile: UserProfile?
    @Published var isLoadingProfile = false
    @Published var isLoadingGroups = false
    @Published var isLoadingGroupMembers = false
    @Published var errorMessage: String?
    @Published var prefectureCounts: [String: Int] = [:]
    @Published var regionCounts: [String: Int] = [:]
    
    @AppStorage("userId") private var userId: Int = 0
    
    private let getProfileUseCase: GetProfileUseCase
    private let getUserGroupsUseCase: GetUserGroupsUseCase
    private let getGroupMembersUseCase: GetGroupMembersUseCase
    private let getPrefectureCountsUseCase: GetPrefectureCountsUseCase
    private let getRegionCountsUseCase: GetRegionCountsUseCase
    
    init(
        getProfileUseCase: GetProfileUseCase = GetProfileUseCase(),
        getUserGroupsUseCase: GetUserGroupsUseCase = GetUserGroupsUseCase(),
        getGroupMembersUseCase: GetGroupMembersUseCase = GetGroupMembersUseCase(),
        getPrefectureCountsUseCase: GetPrefectureCountsUseCase = GetPrefectureCountsUseCase(),
        getRegionCountsUseCase: GetRegionCountsUseCase = GetRegionCountsUseCase()
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.getUserGroupsUseCase = getUserGroupsUseCase
        self.getGroupMembersUseCase = getGroupMembersUseCase
        self.getPrefectureCountsUseCase = getPrefectureCountsUseCase
        self.getRegionCountsUseCase = getRegionCountsUseCase
        setupNotifications()
        fetchUserProfile()
        fetchUserGroups()
        fetchVisitCounts()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleGroupJoined),
            name: .groupJoined,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleGroupCreated),
            name: .groupCreated,
            object: nil
        )
    }
    
    @objc private func handleGroupJoined(_ notification: Notification) {
        Task { @MainActor in
            await fetchUserGroups()
            
            // 参加したグループを選択状態にする
            if let groupId = notification.userInfo?["groupId"] as? Int,
               let joinedGroup = userGroups.first(where: { $0.id == groupId }) {
                selectedGroup = joinedGroup
                await fetchGroupMembers(groupId: groupId)
            }
        }
    }
    
    @objc private func handleGroupCreated(_ notification: Notification) {
        Task { @MainActor in
            await fetchUserGroups()
            
            // 作成したグループを選択状態にする
            if let groupId = notification.userInfo?["groupId"] as? Int,
               let createdGroup = userGroups.first(where: { $0.id == groupId }) {
                selectedGroup = createdGroup
                await fetchGroupMembers(groupId: groupId)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func fetchUserProfile() {
        isLoadingProfile = true
        errorMessage = nil
        
        Task {
            do {
                let profile = try await getProfileUseCase.execute(userId: userId)
                await MainActor.run {
                    self.userProfile = profile
                    self.currentUser = profile
                    self.isLoadingProfile = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "プロフィールの取得に失敗しました"
                    self.isLoadingProfile = false
                }
            }
        }
    }
    
    private func fetchUserGroups() {
        isLoadingGroups = true
        errorMessage = nil
        
        Task {
            do {
                let groups = try await getUserGroupsUseCase.execute(userId: userId)
                await MainActor.run {
                    self.userGroups = groups
                    self.isLoadingGroups = false
                }
                
                // グループ一覧取得後、各グループのメンバー情報を取得
                for group in groups {
                    await fetchGroupMembers(groupId: group.id)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "グループの取得に失敗しました"
                    self.isLoadingGroups = false
                }
            }
        }
    }
    
    private func fetchGroupMembers(groupId: Int) async {
        do {
            let members = try await getGroupMembersUseCase.execute(groupId: groupId)
            await MainActor.run {
                if let index = self.userGroups.firstIndex(where: { $0.id == groupId }) {
                    var updatedGroup = self.userGroups[index]
                    updatedGroup.users = members
                    self.userGroups[index] = updatedGroup
                    
                    if self.selectedGroup?.id == groupId {
                        self.selectedGroup = updatedGroup
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "グループ「\(self.userGroups.first(where: { $0.id == groupId })?.name ?? "")」のメンバー取得に失敗しました"
            }
        }
    }
    
    private func fetchVisitCounts() {
        Task {
            await fetchPrefectureCounts()
            await fetchRegionCounts()
        }
    }
    
    private func fetchPrefectureCounts() async {
        do {
            let groupIds = selectedGroup.map { [$0.id] } ?? []
            let counts = try await getPrefectureCountsUseCase.execute(groupIds: groupIds)
            await MainActor.run {
                self.prefectureCounts = Dictionary(uniqueKeysWithValues: counts.map { ($0.prefectureName, $0.count) })
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "都道府県別訪問回数の取得に失敗しました"
            }
        }
    }
    
    private func fetchRegionCounts() async {
        do {
            let groupIds = selectedGroup.map { [$0.id] } ?? []
            let counts = try await getRegionCountsUseCase.execute(groupIds: groupIds)
            await MainActor.run {
                self.regionCounts = Dictionary(uniqueKeysWithValues: counts.map { ($0.regionName, $0.count) })
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "地域別訪問回数の取得に失敗しました"
            }
        }
    }
    
    // 選択されたグループの合計訪問回数を取得
    func getGroupVisitCount(for region: AMRegion) -> Int {
        return regionCounts[region.name] ?? 0
    }
    
    func getGroupVisitCount(for prefecture: AMPrefecture) -> Int {
        return prefectureCounts[prefecture.name] ?? 0
    }
    
    // 個別ユーザーの訪問回数を取得
    func getVisitCount(for region: AMRegion) -> Int {
        return regionCounts[region.name] ?? 0
    }
    
    func getVisitCount(for prefecture: AMPrefecture) -> Int {
        return prefectureCounts[prefecture.name] ?? 0
    }
    
    // グループまたはユーザーの選択を更新
    func selectGroup(_ group: UserGroup) {
        selectedGroup = group
        selectedGroupMember = nil  // グループ選択時はメンバー選択をリセット
        
        // メンバー情報が空の場合のみ再取得
        if group.users.isEmpty {
            Task {
                await fetchGroupMembers(groupId: group.id)
            }
        }
    }
    
    func selectGroupMember(_ member: UserProfile) {
        selectedGroupMember = member
    }
    
    func resetSelection() {
        selectedGroup = nil
        selectedGroupMember = nil
    }
    
    func toggleMapType() {
        isShowingDetailMap.toggle()
        // 地図タイプを切り替えるときに選択状態をリセット
        selectedRegion = nil
        selectedPrefecture = nil
    }
    
    func constrainOffset(_ offset: CGSize, in geometrySize: CGSize, scale: CGFloat) -> CGSize {
        let maxHeight = geometrySize.height * 0.6
        let mapHeight = geometrySize.height * 0.4
        let scaledMapHeight = mapHeight * scale
        
        // 地図の中心から移動可能な距離を計算
        let verticalLimit = (maxHeight - mapHeight) / 2
        
        // 地図の幅に基づく水平方向の制限
        let mapWidth = geometrySize.width * 0.8
        let scaledMapWidth = mapWidth * scale
        let horizontalLimit = (geometrySize.width - mapWidth) / 2
        
        // スケールに応じて移動可能範囲を調整
        let adjustedVerticalLimit = verticalLimit + abs(scaledMapHeight - mapHeight) / 2
        let adjustedHorizontalLimit = horizontalLimit + abs(scaledMapWidth - mapWidth) / 2
        
        return CGSize(
            width: max(min(offset.width, adjustedHorizontalLimit), -adjustedHorizontalLimit),
            height: max(min(offset.height, adjustedVerticalLimit), -adjustedVerticalLimit)
        )
    }
}
