import SwiftUI
import AMJpnMap

struct PrefectualMapOfJapanView: View {
    @StateObject private var viewModel = PrefectualMapOfJapanViewModel()
    @State private var isDrawerOpen = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
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
                    }
                    
                    HStack {
                        Spacer()
                        if viewModel.isShowingDetailMap {
                            JapanDetailMapViewRepresentable(viewModel: viewModel)
                                .frame(width: geometry.size.width * 0.8,
                                       height: geometry.size.height * 0.5)
                        } else {
                            JapanMapViewRepresentable(viewModel: viewModel)
                                .frame(width: geometry.size.width * 0.8,
                                       height: geometry.size.height * 0.5)
                        }
                        Spacer()
                    }
                    
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
