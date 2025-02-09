import Foundation

struct FoundGroup {
    let name: String
    let icon: String
}

extension Notification.Name {
    static let groupJoined = Notification.Name("groupJoined")
}

@MainActor
class JoinGroupViewModel: ObservableObject {
    @Published var groupId: String = ""
    @Published var password: String = ""
    @Published var foundGroup: FoundGroup?
    @Published var isSearching = false
    @Published var isJoining = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let getGroupUseCase: GetGroupUseCase
    
    init(getGroupUseCase: GetGroupUseCase = GetGroupUseCase()) {
        self.getGroupUseCase = getGroupUseCase
    }
    
    func searchGroup() {
        guard !groupId.isEmpty else {
            showError = true
            errorMessage = "グループIDを入力してください"
            return
        }
        
        guard let groupIdInt = Int(groupId) else {
            showError = true
            errorMessage = "グループIDは数値で入力してください"
            return
        }
        
        isSearching = true
        showError = false
        foundGroup = nil
        
        Task {
            do {
                let group = try await getGroupUseCase.execute(groupId: groupIdInt)
                foundGroup = FoundGroup(
                    name: group.name,
                    icon: group.imageURL ?? ""
                )
            } catch {
                showError = true
                errorMessage = "グループが見つかりませんでした"
            }
            isSearching = false
        }
    }
    
    func joinGroup() {
        guard !password.isEmpty else {
            showError = true
            errorMessage = "パスワードを入力してください"
            return
        }
        
        isJoining = true
        
        // TODO: 実際のAPI呼び出しに置き換える
        // 開発用のモックデータ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.password == "test123" {
                // TODO: グループ参加成功時の処理
                NotificationCenter.default.post(name: .groupJoined, object: nil)
            } else {
                self.showError = true
                self.errorMessage = "パスワードが正しくありません"
            }
            self.isJoining = false
        }
    }
}
