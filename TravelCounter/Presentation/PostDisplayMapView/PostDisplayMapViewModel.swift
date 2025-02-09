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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getMapPostsUseCase: GetMapPostsUseCase
    private let getPostDetailUseCase: GetPostDetailUseCase
    private let geocoder = CLGeocoder()
    private var lastUpdateTime: Date = Date()
    private var isUpdating = false
    private var updateTimer: Timer?
    
    init(
        getMapPostsUseCase: GetMapPostsUseCase = GetMapPostsUseCase(),
        getPostDetailUseCase: GetPostDetailUseCase = GetPostDetailUseCase()
    ) {
        self.getMapPostsUseCase = getMapPostsUseCase
        self.getPostDetailUseCase = getPostDetailUseCase
    }
    
    func focusOnPrefecture(_ prefecture: AMPrefecture) {
        selectedPrefecture = prefecture
        let location = prefecture.location
        
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: location.zoomLevel, longitudeDelta: location.zoomLevel)
        )
        
        // 都道府県が変更されたら投稿を再取得
        Task {
            await fetchPosts(for: prefecture)
        }
    }
    
    private func fetchPosts(for prefecture: AMPrefecture) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // TODO: 選択されているグループIDを取得する
            let groupIds: [Int] = [1] // 仮の実装
            let posts = try await getMapPostsUseCase.execute(
                prefectureId: prefecture.name,
                groupIds: groupIds
            )
            
            await MainActor.run {
                self.posts = posts
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "投稿の取得に失敗しました"
                isLoading = false
            }
        }
    }
    
    func selectPost(_ post: Post) async {
        do {
            let detailPost = try await getPostDetailUseCase.execute(postId: post.id)
            await MainActor.run {
                self.selectedPost = detailPost
                self.showingPostDetail = true
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "投稿の詳細取得に失敗しました"
            }
        }
    }
    
    func scheduleVisiblePrefecturesUpdate(for region: MKCoordinateRegion) {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
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
