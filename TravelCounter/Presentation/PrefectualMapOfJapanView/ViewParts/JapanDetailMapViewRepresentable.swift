//
//  JapanDetailMapViewRepresentable.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/03.
//

import SwiftUI
import AMJpnMap

struct JapanDetailMapViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: PrefectualMapOfJapanViewModel
    
    func makeUIView(context: Context) -> AMJpnMapDetailView {
        let mapView = AMJpnMapDetailView()
        
        // デフォルトの色を設定
        mapView.strokeColor = .gray
        mapView.fillColor = .systemGray5
        
        // 都道府県ごとの色を設定（遅延実行）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for prefecture in AMPrefecture.allCases {
                let color = viewModel.getColorForPrefecture(prefecture)
                mapView.setFillColor(color: color, prefecture: prefecture)
                mapView.setStrokeColor(color: .gray, prefecture: prefecture)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: AMJpnMapDetailView, context: Context) {
        // 必要に応じて更新処理を追加
    }
}
