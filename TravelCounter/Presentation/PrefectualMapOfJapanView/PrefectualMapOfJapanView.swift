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
        NavigationView {
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
                                    .padding(.all, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Spacer()
                          
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
                                                .frame(width: geometry.size.width * 0.9,
                                                       height: geometry.size.height * 0.4)
                                        } else {
                                            JapanMapViewRepresentable(viewModel: viewModel)
                                                .frame(width: geometry.size.width * 0.9,
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
                                ForEach([(0, "0回"), (1, "1回"), (2, "2-3回"), (4, "4-5回"), (6, "6回以上")], id: \.0) { count, label in
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
                                    if let group = viewModel.selectedGroup {
                                        if let member = viewModel.selectedGroupMember {
                                            Text("\(selectedRegion.name)地方: \(viewModel.getVisitCount(for: selectedRegion))回訪問")
                                                .font(.headline)
                                            Text("(\(member.name)さんの訪問数)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("\(selectedRegion.name)地方: \(viewModel.getGroupVisitCount(for: selectedRegion))回訪問")
                                                .font(.headline)
                                            Text("(\(group.name)メンバー全員の合計)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    } else {
                                        Text("\(selectedRegion.name)地方: \(viewModel.getVisitCount(for: selectedRegion))回訪問")
                                            .font(.headline)
                                    }
                                }
                                
                                if viewModel.isShowingDetailMap, let selectedPrefecture = viewModel.selectedPrefecture {
                                    if let group = viewModel.selectedGroup {
                                        if let member = viewModel.selectedGroupMember {
                                            Text("\(selectedPrefecture.name): \(viewModel.getVisitCount(for: selectedPrefecture))回訪問")
                                                .font(.title3)
                                            Text("(\(member.name)さんの訪問数)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("\(selectedPrefecture.name): \(viewModel.getGroupVisitCount(for: selectedPrefecture))回訪問")
                                                .font(.title3)
                                            Text("(\(group.name)メンバー全員の合計)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    } else {
                                        Text("\(selectedPrefecture.name): \(viewModel.getVisitCount(for: selectedPrefecture))回訪問")
                                            .font(.title3)
                                    }
                                    
                                    NavigationLink {
                                        PostDisplayMapView(selectedPrefecture: selectedPrefecture)
                                    } label: {
                                        Text("\(selectedPrefecture.name)の投稿を地図上で表示")
                                            .padding(.all, 12)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            .padding()
                            
                            Spacer()
                        }
                    }
                }
                .background(isDrawerOpen ? Color.white : Color.clear)
                
                DrawerView(
                    width: UIScreen.main.bounds.width * 0.7,
                    isOpen: isDrawerOpen,
                    onClose: { isDrawerOpen = false },
                    currentUser: viewModel.currentUser,
                    userGroups: viewModel.userGroups,
                    selectedGroup: viewModel.selectedGroup,
                    selectedGroupMember: viewModel.selectedGroupMember,
                    onUserSelect: { user in
                        viewModel.selectGroupMember(user)
                    },
                    onGroupSelect: { group in
                        viewModel.selectGroup(group)
                    },
                    onResetSelect: {
                        viewModel.resetSelection()
                    }
                )
                .zIndex(1)
            }
            .navigationBarHidden(true)
        }
    }
}
