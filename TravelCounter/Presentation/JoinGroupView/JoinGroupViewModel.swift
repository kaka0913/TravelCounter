import Foundation

struct FoundGroup {
    let name: String
    let icon: String
}

extension Notification.Name {
    static let groupJoined = Notification.Name("groupJoined")
} 

class JoinGroupViewModel: ObservableObject {
    @Published var groupId: String = ""
    @Published var password: String = ""
    @Published var foundGroup: FoundGroup?
    @Published var isSearching = false
    @Published var isJoining = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    func searchGroup() {
        guard !groupId.isEmpty else {
            showError = true
            errorMessage = "グループIDを入力してください"
            return
        }
        
        isSearching = true
        
        // TODO: 実際のAPI呼び出しに置き換える
        // 開発用のモックデータ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.groupId == "123" {
                self.foundGroup = FoundGroup(
                    name: "テストグループ",
                    icon: "https://example.com/group-icon.jpg"
                )
            } else {
                self.showError = true
                self.errorMessage = "グループが見つかりませんでした"
            }
            self.isSearching = false
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
