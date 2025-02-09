import Foundation
import SwiftUI

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
    
    @AppStorage("userId") private var userId: Int = 0
    private let getGroupUseCase: GetGroupUseCase
    private let joinGroupUseCase: JoinGroupUseCase
    
    init(
        getGroupUseCase: GetGroupUseCase = GetGroupUseCase(),
        joinGroupUseCase: JoinGroupUseCase = JoinGroupUseCase()
    ) {
        self.getGroupUseCase = getGroupUseCase
        self.joinGroupUseCase = joinGroupUseCase
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
        
        guard let groupIdInt = Int(groupId) else {
            showError = true
            errorMessage = "グループIDが不正です"
            return
        }
        
        isJoining = true
        showError = false
        
        Task {
            do {
                let joinedGroupId = try await joinGroupUseCase.execute(
                    userId: userId,
                    groupId: groupIdInt,
                    password: password
                )
                
                // グループ参加成功を通知
                NotificationCenter.default.post(
                    name: .groupJoined,
                    object: nil,
                    userInfo: ["groupId": joinedGroupId]
                )
                
                isJoining = false
            } catch {
                showError = true
                errorMessage = "グループへの参加に失敗しました。パスワードを確認してください。"
                isJoining = false
            }
        }
    }
}
