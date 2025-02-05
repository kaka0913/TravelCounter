//
//  JapanDetailMapViewRepresentable.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/03.
//

import SwiftUI
import AMJpnMap

struct JapanDetailMapViewRepresentable: UIViewRepresentable {
    //本来はviewModelを記述すべきではないが可読性を優先させるために記述
    @ObservedObject var viewModel: PrefectualMapOfJapanViewModel
    
    // 訪問回数に応じた色を返す
    private func getColorForCount(_ count: Int) -> UIColor {
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
    
    // 都道府県の訪問回数に基づく色を取得
    private func getColorForPrefecture(_ prefecture: AMPrefecture) -> UIColor {
        let count: Int
        if let group = viewModel.selectedGroup {
            if let member = viewModel.selectedGroupMember {
                // メンバーが選択されている場合は、そのメンバーの訪問回数
                count = viewModel.getVisitCount(for: prefecture)
            } else {
                // グループが選択されている場合は、グループ全体の訪問回数
                count = viewModel.getGroupVisitCount(for: prefecture)
            }
        } else {
            // グループもメンバーも選択されていない場合は、現在のユーザーの訪問回数
            count = viewModel.getVisitCount(for: prefecture)
        }
        return getColorForCount(count)
    }
    
    func makeUIView(context: Context) -> AMJpnMapDetailView {
        let mapView = AMJpnMapDetailView()
        
        // デフォルトの色を設定
        mapView.strokeColor = .gray
        mapView.fillColor = .systemGray5
        
        // コールバックを設定
        mapView.didSelectPrefecture = { prefecture in
            viewModel.selectedPrefecture = prefecture
            // 対応する地域も選択
            viewModel.selectedRegion = prefecture.region
            
            // 選択時の視覚的フィードバック
            let baseColor = getColorForPrefecture(prefecture)
            mapView.setFillColor(color: baseColor.withAlphaComponent(1.0), prefecture: prefecture)
            mapView.setStrokeColor(color: .black, prefecture: prefecture)
        }
        
        mapView.didDeselectPrefecture = { prefecture in
            if viewModel.selectedPrefecture == prefecture {
                viewModel.selectedPrefecture = nil
                // 地域の選択も解除
                viewModel.selectedRegion = nil
            }
            
            // 選択解除時の視覚的フィードバック
            let originalColor = getColorForPrefecture(prefecture)
            mapView.setFillColor(color: originalColor.withAlphaComponent(0.7), prefecture: prefecture)
            mapView.setStrokeColor(color: .gray, prefecture: prefecture)
        }
        
        // 都道府県ごとの色を設定（遅延実行）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for prefecture in AMPrefecture.allCases {
                let color = getColorForPrefecture(prefecture)
                mapView.setFillColor(color: color.withAlphaComponent(0.7), prefecture: prefecture)
                mapView.setStrokeColor(color: .gray, prefecture: prefecture)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: AMJpnMapDetailView, context: Context) {
        for prefecture in AMPrefecture.allCases {
            let color = getColorForPrefecture(prefecture)
            if viewModel.selectedPrefecture == prefecture {
                uiView.setFillColor(color: color.withAlphaComponent(1.0), prefecture: prefecture)
                uiView.setStrokeColor(color: .black, prefecture: prefecture)
            } else {
                uiView.setFillColor(color: color.withAlphaComponent(0.7), prefecture: prefecture)
                uiView.setStrokeColor(color: .gray, prefecture: prefecture)
            }
        }
    }
}
