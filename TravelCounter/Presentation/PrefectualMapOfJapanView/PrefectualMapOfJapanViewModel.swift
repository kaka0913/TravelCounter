import Foundation
import AMJpnMap
import UIKit

class PrefectualMapOfJapanViewModel: ObservableObject {
    @Published var selectedRegion: AMRegion?
    @Published var selectedPrefecture: AMPrefecture?
    @Published var isShowingDetailMap: Bool = false
    @Published var currentUser: UserProfile?
    @Published var userGroups: [UserGroup] = []
    
    // モックデータ: 地域ごとの訪問回数
    private var regionVisitCounts: [AMRegion: Int] = [
        .hokkaido: 2,
        .tohoku: 3,
        .kanto: 10,
        .chubu: 1,
        .kinki: 5,
        .chugoku: 0,
        .shikoku: 1,
        .kyushu: 4
    ]
    
    // モックデータ: 都道府県ごとの訪問回数
    private var prefectureVisitCounts: [AMPrefecture: Int] = [
        .hokkaido: 2,
        .tokyo: 5,
        .osaka: 3,
        .kyoto: 2,
        .fukuoka: 1,
        .okinawa: 3
    ]
    
    init() {
        // モックデータの設定
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
            ),
            UserGroup(
                id: 3,
                name: "同僚",
                iconName: "briefcase.fill",
                users: [
                    UserProfile(id: 6, name: "同僚A", imageURL: nil),
                    UserProfile(id: 7, name: "同僚B", imageURL: nil),
                    UserProfile(id: 8, name: "同僚C", imageURL: nil)
                ]
            )
        ]
    }
    
    func selectRegion(_ region: AMRegion) {
        selectedRegion = region
    }
    
    func deselectRegion(_ region: AMRegion) {
        if selectedRegion == region {
            selectedRegion = nil
        }
    }
    
    func selectPrefecture(_ prefecture: AMPrefecture) {
        selectedPrefecture = prefecture
    }
    
    func deselectPrefecture(_ prefecture: AMPrefecture) {
        if selectedPrefecture == prefecture {
            selectedPrefecture = nil
        }
    }
    
    func toggleMapType() {
        isShowingDetailMap.toggle()
        // 地図タイプを切り替えるときに選択状態をリセット
        selectedRegion = nil
        selectedPrefecture = nil
    }
    
    // 訪問回数を取得
    func getVisitCount(for region: AMRegion) -> Int {
        return regionVisitCounts[region] ?? 0
    }
    
    func getVisitCount(for prefecture: AMPrefecture) -> Int {
        return prefectureVisitCounts[prefecture] ?? 0
    }
}
