//
//  PostDisplayViewModel.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI
import MapKit
import AMJpnMap

class PostDisplayMapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671),  // 東京
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var posts: [Post] = []
    @Published var visiblePrefectures: Set<String> = []
    @Published var selectedPost: Post? = nil
    @Published var showingPostDetail = false
    @Published var selectedPrefecture: AMPrefecture?
    
    private let geocoder = CLGeocoder()
    private var lastUpdateTime: Date = Date()
    private var isUpdating = false
    private var updateTimer: Timer?
    
    init() {
        // サンプルデータ
        let dateFormatter = ISO8601DateFormatter()
        posts = [
            Post(id: 1,
                 userId: 101,
                 userName: "山田太郎",
                 image: "sample1",
                 comment: "東京タワーに行ってきました！",
                 date: dateFormatter.date(from: "2025-01-30T15:04:05Z") ?? Date(),
                 coordinate: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671)),
            Post(id: 2,
                 userId: 102,
                 userName: "鈴木花子",
                 image: "sample2",
                 comment: "スカイツリーの夜景が綺麗でした",
                 date: dateFormatter.date(from: "2025-02-01T18:30:00Z") ?? Date(),
                 coordinate: CLLocationCoordinate2D(latitude: 35.6912, longitude: 139.7771))
        ]
    }
    
    func focusOnPrefecture(_ prefecture: AMPrefecture) {
        selectedPrefecture = prefecture
        let location = prefecture.location
        
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: location.zoomLevel, longitudeDelta: location.zoomLevel)
        )
    }
    
    func scheduleVisiblePrefecturesUpdate(for region: MKCoordinateRegion) {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.updateVisiblePrefectures(for: region)
        }
    }
    
    func updateVisiblePrefectures(for region: MKCoordinateRegion) {
        guard !isUpdating else { return }
        isUpdating = true
        
        let center = CLLocation(latitude: region.center.latitude,
                              longitude: region.center.longitude)
        
        geocoder.reverseGeocodeLocation(center) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let prefecture = placemarks?.first?.administrativeArea {
                    let newVisiblePrefectures: Set<String> = [prefecture]
                    if newVisiblePrefectures != self.visiblePrefectures {
                        self.visiblePrefectures = newVisiblePrefectures
                        //TODO: 都道府県が変わった時の処理
                        print("表示されている都道府県が変更されました: \(Array(newVisiblePrefectures))")
                    }
                }
                self.isUpdating = false
            }
        }
    }
    
    deinit {
        updateTimer?.invalidate()
    }
}
