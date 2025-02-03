//
//  JapanMapViewRepresentable.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/03.
//

import SwiftUI
import AMJpnMap

struct JapanMapViewRepresentable: UIViewRepresentable {
     //本来はviewModelを記述すべきではないが可読性を優先させるために記述
    @ObservedObject var viewModel: PrefectualMapOfJapanViewModel
    
    // 地域の訪問回数に基づく色を取得
    private func getColorForRegion(_ region: AMRegion) -> UIColor {
        let count = viewModel.getVisitCount(for: region)
        return ColorUtility.getColorForCount(count)
    }
    
    func makeUIView(context: Context) -> AMJpnMapView {
        let mapView = AMJpnMapView()
        
        // デリゲートを設定
        mapView.delegate = context.coordinator
        context.coordinator.parent = self

        // デフォルトの色を設定
        mapView.strokeColor = .gray
        mapView.fillColor = .systemGray5
        
        
        // 地域ごとの色を設定（遅延実行）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for region in AMRegion.allCases {
                let color = getColorForRegion(region)
                mapView.setFillColor(color: color.withAlphaComponent(0.7), region: region)
                mapView.setStrokeColor(color: .gray, region: region)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: AMJpnMapView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for region in AMRegion.allCases {
                let color = getColorForRegion(region)
                if viewModel.selectedRegion == region {
                    uiView.setFillColor(color: color.withAlphaComponent(1.0), region: region)
                    uiView.setStrokeColor(color: .black, region: region)
                } else {
                    uiView.setFillColor(color: color.withAlphaComponent(0.7), region: region)
                    uiView.setStrokeColor(color: .gray, region: region)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, AMJpnMapViewDelegate {
        private var viewModel: PrefectualMapOfJapanViewModel
        var parent: JapanMapViewRepresentable?
        
        init(viewModel: PrefectualMapOfJapanViewModel) {
            self.viewModel = viewModel
        }
        
        func jpnMapView(_ jpnMapView: AMJpnMapView, didSelectAtRegion region: AMRegion) {
            viewModel.selectRegion(region)
            
            // 選択時の視覚的フィードバック
            let baseColor = parent?.getColorForRegion(region) ?? .systemGray5
            jpnMapView.setFillColor(color: baseColor.withAlphaComponent(1.0), region: region)
            jpnMapView.setStrokeColor(color: .black, region: region)
        }
        
        func jpnMapView(_ jpnMapView: AMJpnMapView, didDeselectAtRegion region: AMRegion) {
            viewModel.deselectRegion(region)
            
            // 選択解除時の視覚的フィードバック
            let originalColor = parent?.getColorForRegion(region) ?? .systemGray5
            jpnMapView.setFillColor(color: originalColor.withAlphaComponent(0.7), region: region)
            jpnMapView.setStrokeColor(color: .gray, region: region)
        }
    }
}
