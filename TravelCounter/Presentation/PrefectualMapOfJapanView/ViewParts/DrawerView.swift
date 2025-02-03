import SwiftUI

struct DrawerView: View {
    let width: CGFloat
    let isOpen: Bool
    let onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Color.white
                VStack(alignment: .leading, spacing: 40) {
                    Text("メニュー")
                        .font(.headline)
                        .padding(.top, 40)
                        .padding(.leading, 8)
                    
                    // ここにメニュー項目を追加
                    Button(action: {
                        // アクション
                    }) {
                        Label("設定", systemImage: "gear")
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        // アクション
                    }) {
                        Label("統計", systemImage: "chart.bar")
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
            }
            .frame(width: width)
            .offset(x: isOpen ? 0 : -width)
            .animation(.easeInOut(duration: 0.3), value: isOpen)
            
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onClose()
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isOpen)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
} 