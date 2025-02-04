import SwiftUI
import AMJpnMap

struct PrefectualMapOfJapanView: View {
    @StateObject private var viewModel = PrefectualMapOfJapanViewModel()
    @State private var isDrawerOpen = false
    @State private var mapScale: CGFloat = 1.0
    @State private var mapOffset: CGSize = .zero
    @State private var lastMapOffset: CGSize = .zero
    @State private var magnificationScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // ヘッダー部分
                    HStack {
                        Button(action: {
                            isDrawerOpen.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding()
                        }
                        Spacer()
                        
                        if mapScale != 1.0 || mapOffset != .zero {
                            Button(action: {
                                withAnimation {
                                    mapScale = 1.0
                                    magnificationScale = 1.0
                                    mapOffset = .zero
                                    lastMapOffset = .zero
                                }
                            }) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding()
                            }
                        }
                    }
                    
                    // 地図部分（固定高さ）
                    ZStack {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: geometry.size.height * 0.6)
                            .clipped()
                            .overlay(
                                ZStack {
                                    if viewModel.isShowingDetailMap {
                                        JapanDetailMapViewRepresentable(viewModel: viewModel)
                                            .frame(width: geometry.size.width * 0.8,
                                                   height: geometry.size.height * 0.4)
                                    } else {
                                        JapanMapViewRepresentable(viewModel: viewModel)
                                            .frame(width: geometry.size.width * 0.8,
                                                   height: geometry.size.height * 0.4)
                                    }
                                }
                                .scaleEffect(mapScale)
                                .offset(x: viewModel.constrainOffset(mapOffset, in: geometry.size, scale: mapScale).width,
                                        y: viewModel.constrainOffset(mapOffset, in: geometry.size, scale: mapScale).height)
                                .gesture(
                                    SimultaneousGesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let newOffset = CGSize(
                                                    width: lastMapOffset.width + value.translation.width,
                                                    height: lastMapOffset.height + value.translation.height
                                                )
                                                mapOffset = viewModel.constrainOffset(newOffset, in: geometry.size, scale: mapScale)
                                            }
                                            .onEnded { value in
                                                lastMapOffset = mapOffset
                                            },
                                        MagnificationGesture()
                                            .onChanged { value in
                                                let newScale = value.magnitude * magnificationScale
                                                mapScale = min(max(newScale, 0.5), 3.0)
                                                mapOffset = viewModel.constrainOffset(mapOffset, in: geometry.size, scale: mapScale)
                                            }
                                            .onEnded { value in
                                                magnificationScale = mapScale
                                                mapOffset = viewModel.constrainOffset(mapOffset, in: geometry.size, scale: mapScale)
                                                lastMapOffset = mapOffset
                                            }
                                    )
                                )
                            )
                    }
                    .frame(height: geometry.size.height * 0.6)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("訪問回数")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        HStack {
                            ForEach([(0, "未訪問"), (1, "1回"), (2, "2-3回"), (4, "4-5回"), (6, "6回以上")], id: \.0) { count, label in
                                HStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(ColorUtility.getColorForCount(count)))
                                        .frame(width: 20, height: 20)
                                    Text(label)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding()
                    
                    if let selectedRegion = viewModel.selectedRegion {
                        VStack(spacing: 8) {
                            if viewModel.isShowingDetailMap {
                                Text("\(selectedRegion.name)地方")
                                    .font(.headline)
                            } else {
                                Text("\(selectedRegion.name)地方: \(viewModel.getVisitCount(for: selectedRegion))回訪問")
                                    .font(.headline)
                            }
                            
                            if viewModel.isShowingDetailMap, let selectedPrefecture = viewModel.selectedPrefecture {
                                Text("\(selectedPrefecture.name): \(viewModel.getVisitCount(for: selectedPrefecture))回訪問")
                                    .font(.title2)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // マップ切り替え時にズームとオフセットをリセット
                        withAnimation {
                            mapScale = 1.0
                            magnificationScale = 1.0
                            mapOffset = .zero
                            lastMapOffset = .zero
                        }
                        viewModel.toggleMapType()
                    }) {
                        Text(viewModel.isShowingDetailMap ? "地方マップ" : "詳細マップ")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
            }
            .background(isDrawerOpen ? Color.white : Color.clear)
            
            DrawerView(
                width: UIScreen.main.bounds.width * 0.7,
                isOpen: isDrawerOpen,
                onClose: { isDrawerOpen = false },
                currentUser: viewModel.currentUser,
                userGroups: viewModel.userGroups,
                onUserSelect: { user in
                    print("Selected user: \(user.name)")
                }
            )
            .zIndex(1)
        }
    }
}
