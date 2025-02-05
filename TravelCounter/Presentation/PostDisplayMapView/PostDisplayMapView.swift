//
//  PostDisplayView.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI
import MapKit
import AMJpnMap

struct PostDisplayMapView: View {
    let selectedPrefecture: AMPrefecture?
    @StateObject private var viewModel = PostDisplayMapViewModel()
    @State private var mapType: MKMapType = .standard
    
    init(selectedPrefecture: AMPrefecture? = nil) {
        self.selectedPrefecture = selectedPrefecture
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.none),
                    annotationItems: viewModel.posts) { post in
                        MapAnnotation(coordinate: post.coordinate) {
                            PostAnnotation(post: post)
                                .onTapGesture {
                                    viewModel.selectedPost = post
                                    viewModel.showingPostDetail = true
                                }
                        }
                }
                .onAppear {
                    if let prefecture = selectedPrefecture {
                        viewModel.focusOnPrefecture(prefecture)
                    }
                    viewModel.updateVisiblePrefectures(for: viewModel.region)
                }
                .onChange(of: viewModel.region.center.latitude) { oldValue, newValue in
                    viewModel.scheduleVisiblePrefecturesUpdate(for: viewModel.region)
                }
                .onChange(of: viewModel.region.center.longitude) { oldValue, newValue in
                    viewModel.scheduleVisiblePrefecturesUpdate(for: viewModel.region)
                }
                .ignoresSafeArea(edges: .bottom)
                
                if viewModel.showingPostDetail {
                    if let post = viewModel.selectedPost {
                        PostDetailView(post: post, onDismiss: {
                            viewModel.showingPostDetail = false
                        })
                        .frame(height: UIScreen.main.bounds.height * 0.45)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: viewModel.showingPostDetail)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(Array(viewModel.visiblePrefectures).first ?? "地図")
    }
}
