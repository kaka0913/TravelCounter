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
        
        // コールバックを設定
        mapView.didSelectPrefecture = { prefecture in
            viewModel.selectPrefecture(prefecture)
            // 対応する地域も選択
            viewModel.selectRegion(prefecture.region)
            
            // 選択時の視覚的フィードバック
            let baseColor = viewModel.getColorForPrefecture(prefecture)
            mapView.setFillColor(color: baseColor.withAlphaComponent(1.0), prefecture: prefecture)
            mapView.setStrokeColor(color: .black, prefecture: prefecture)
        }
        
        mapView.didDeselectPrefecture = { prefecture in
            viewModel.deselectPrefecture(prefecture)
            // 地域の選択も解除
            viewModel.deselectRegion(prefecture.region)
            
            // 選択解除時の視覚的フィードバック
            let originalColor = viewModel.getColorForPrefecture(prefecture)
            mapView.setFillColor(color: originalColor.withAlphaComponent(0.7), prefecture: prefecture)
            mapView.setStrokeColor(color: .gray, prefecture: prefecture)
        }
        
        // 都道府県ごとの色を設定（遅延実行）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for prefecture in AMPrefecture.allCases {
                let color = viewModel.getColorForPrefecture(prefecture)
                mapView.setFillColor(color: color.withAlphaComponent(0.7), prefecture: prefecture)
                mapView.setStrokeColor(color: .gray, prefecture: prefecture)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: AMJpnMapDetailView, context: Context) {
        for prefecture in AMPrefecture.allCases {
            let color = viewModel.getColorForPrefecture(prefecture)
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
