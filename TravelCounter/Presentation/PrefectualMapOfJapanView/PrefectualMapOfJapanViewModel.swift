import Foundation
import AMJpnMap
import UIKit

class PrefectualMapOfJapanViewModel: ObservableObject {
    @Published var selectedRegion: AMRegion?
    @Published var selectedPrefecture: AMPrefecture?
    @Published var isShowingDetailMap: Bool = false
    
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
    
    // 訪問回数に基づく色を取得（地域用）
    func getColorForRegion(_ region: AMRegion) -> UIColor {
        let count = regionVisitCounts[region] ?? 0
        return getColorForCount(count)
    }
    
    // 訪問回数に基づく色を取得（都道府県用）
    func getColorForPrefecture(_ prefecture: AMPrefecture) -> UIColor {
        let count = prefectureVisitCounts[prefecture] ?? 0
        return getColorForCount(count)
    }
    
    // 訪問回数に応じた色を返す
    func getColorForCount(_ count: Int) -> UIColor {
        switch count {
        case 0:
            return .systemGray5  // 未訪問
        case 1:
            return .systemYellow.withAlphaComponent(0.7)  // 1回
        case 2...3:
            return .systemGreen.withAlphaComponent(0.7)   // 2-3回
        case 4...5:
            return .systemBlue.withAlphaComponent(0.7)    // 4-5回
        default:
            return .systemRed.withAlphaComponent(0.7)     // 6回以上
        }
    }
    
    // 訪問回数を取得
    func getVisitCount(for region: AMRegion) -> Int {
        return regionVisitCounts[region] ?? 0
    }
    
    func getVisitCount(for prefecture: AMPrefecture) -> Int {
        return prefectureVisitCounts[prefecture] ?? 0
    }
}
