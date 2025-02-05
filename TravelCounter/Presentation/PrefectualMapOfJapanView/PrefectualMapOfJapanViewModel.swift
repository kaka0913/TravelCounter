import Foundation
import AMJpnMap
import UIKit

class PrefectualMapOfJapanViewModel: ObservableObject {
    @Published var selectedRegion: AMRegion?
    @Published var selectedPrefecture: AMPrefecture?
    @Published var isShowingDetailMap: Bool = false
    @Published var currentUser: UserProfile?
    @Published var userGroups: [UserGroup] = []
    @Published var selectedGroup: UserGroup?
    @Published var selectedGroupMember: UserProfile?
    
    // モックデータ: ユーザーごとの地域訪問回数
    private var userRegionVisitCounts: [Int: [AMRegion: Int]] = [:]
    // モックデータ: ユーザーごとの都道府県訪問回数
    private var userPrefectureVisitCounts: [Int: [AMPrefecture: Int]] = [:]
    
    init() {
        setupMockData()
    }
    
    private func setupMockData() {
        // 現在のユーザーのデータ
        currentUser = UserProfile(id: 0, name: "現在のユーザー", imageURL: nil)
        
        // グループとユーザーのモックデータ
        userGroups = [
            UserGroup(
                id: 1,
                name: "家族",
                iconName: "house.fill",
                users: [
                    UserProfile(id: 1, name: "父", imageURL: nil),
                    UserProfile(id: 2, name: "母", imageURL: nil),
                    UserProfile(id: 3, name: "兄", imageURL: nil)
                ]
            ),
            UserGroup(
                id: 2,
                name: "友達",
                iconName: "person.2.fill",
                users: [
                    UserProfile(id: 4, name: "友達A", imageURL: nil),
                    UserProfile(id: 5, name: "友達B", imageURL: nil)
                ]
            )
        ]
        
        // ユーザーごとの訪問回数データ
        userRegionVisitCounts = [
            0: [.hokkaido: 2, .tohoku: 3, .kanto: 10],  // 現在のユーザー
            1: [.kanto: 5, .kinki: 3],                  // 父
            2: [.tohoku: 2, .kanto: 4, .kinki: 2],      // 母
            3: [.kanto: 3, .chubu: 2],                  // 兄
            4: [.kanto: 6, .kinki: 4],                  // 友達A
            5: [.tohoku: 1, .kanto: 2]                  // 友達B
        ]
        
        userPrefectureVisitCounts = [
            0: [.tokyo: 5, .osaka: 3],      // 現在のユーザー
            1: [.tokyo: 3, .kyoto: 2],      // 父
            2: [.tokyo: 2, .osaka: 1],      // 母
            3: [.tokyo: 4, .kanagawa: 2],   // 兄
            4: [.tokyo: 3, .osaka: 2],      // 友達A
            5: [.miyagi: 1, .tokyo: 1]      // 友達B
        ]
    }
    
    // 選択されたグループの合計訪問回数を取得
    func getGroupVisitCount(for region: AMRegion) -> Int {
        guard let group = selectedGroup else { return getVisitCount(for: region) }
        
        return group.users.reduce(0) { total, user in
            total + (userRegionVisitCounts[user.id]?[region] ?? 0)
        }
    }
    
    func getGroupVisitCount(for prefecture: AMPrefecture) -> Int {
        guard let group = selectedGroup else { return getVisitCount(for: prefecture) }
        
        return group.users.reduce(0) { total, user in
            total + (userPrefectureVisitCounts[user.id]?[prefecture] ?? 0)
        }
    }
    
    // 個別ユーザーの訪問回数を取得
    func getVisitCount(for region: AMRegion) -> Int {
        if let member = selectedGroupMember {
            return userRegionVisitCounts[member.id]?[region] ?? 0
        }
        return userRegionVisitCounts[0]?[region] ?? 0  // デフォルトは現在のユーザー
    }
    
    func getVisitCount(for prefecture: AMPrefecture) -> Int {
        if let member = selectedGroupMember {
            return userPrefectureVisitCounts[member.id]?[prefecture] ?? 0
        }
        return userPrefectureVisitCounts[0]?[prefecture] ?? 0  // デフォルトは現在のユーザー
    }
    
    // グループまたはユーザーの選択を更新
    func selectGroup(_ group: UserGroup) {
        selectedGroup = group
        selectedGroupMember = nil  // グループ選択時はメンバー選択をリセット
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
