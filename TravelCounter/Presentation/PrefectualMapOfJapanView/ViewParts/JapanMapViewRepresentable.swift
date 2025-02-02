//
//  JapanMapViewRepresentable.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/03.
//

import SwiftUI
import AMJpnMap

struct JapanMapViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: PrefectualMapOfJapanViewModel
    
    func makeUIView(context: Context) -> AMJpnMapView {
        let mapView = AMJpnMapView()
        mapView.delegate = context.coordinator
        
        // デフォルトの色を設定
        mapView.strokeColor = .gray
        mapView.fillColor = .systemGray5
        
        // 地域ごとの色を設定（AMJpnMapViewの内部初期化が完了するのを待つための遅延実行）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for region in AMRegion.allCases {
                let color = viewModel.getColorForRegion(region)
                mapView.setFillColor(color: color, region: region)
                mapView.setStrokeColor(color: .gray, region: region)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: AMJpnMapView, context: Context) {
        // 必要に応じて更新処理を追加
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, AMJpnMapViewDelegate {
        private var viewModel: PrefectualMapOfJapanViewModel
        
        init(viewModel: PrefectualMapOfJapanViewModel) {
            self.viewModel = viewModel
        }
        
        func jpnMapView(_ jpnMapView: AMJpnMapView, didSelectAtRegion region: AMRegion) {
            let color = viewModel.getColorForRegion(region)
            jpnMapView.setFillColor(color: color.withAlphaComponent(1.0), region: region)
            jpnMapView.setStrokeColor(color: .black, region: region)
            viewModel.selectRegion(region)
        }
        
        func jpnMapView(_ jpnMapView: AMJpnMapView, didDeselectAtRegion region: AMRegion) {
            let color = viewModel.getColorForRegion(region)
            jpnMapView.setFillColor(color: color, region: region)
            jpnMapView.setStrokeColor(color: .gray, region: region)
            viewModel.deselectRegion(region)
        }
    }
}
