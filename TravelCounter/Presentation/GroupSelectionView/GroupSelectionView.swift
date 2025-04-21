import SwiftUI

enum GroupNavigationType: Hashable {
    case create
    case join
}

struct GroupSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                NavigationLink(value: GroupNavigationType.create) {
                    GroupSelectionButton(
                        title: "新規グループを作成",
                        subtitle: "新しいグループを作成",
                        systemImage: "plus.circle.fill"
                    )
                }
                
                NavigationLink(value: GroupNavigationType.join) {
                    GroupSelectionButton(
                        title: "既存グループに参加",
                        subtitle: "IDとパスワードを入力して参加",
                        systemImage: "person.2.fill"
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("グループ選択")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: GroupNavigationType.self) { type in
                switch type {
                case .create:
                    CreateNewGroupView()
                case .join:
                    JoinGroupView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .groupCreated)) { _ in
                dismiss()
            }
            .onReceive(NotificationCenter.default.publisher(for: .groupJoined)) { _ in
                dismiss()
            }
        }
    }
}
