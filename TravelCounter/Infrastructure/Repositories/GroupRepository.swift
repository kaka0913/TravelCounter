import Foundation
import Alamofire

class GroupRepository: GroupRepositoryProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func getUserGroups(userId: Int) async throws -> [UserGroup] {
        #if DEBUG
        return try await debugGetUserGroups(userId: userId)
        #else
        let request = GetUserGroupsRequest(userId: userId)
        let response = try await apiClient.call(request: request)
        
        return response.groups.map { group in
            UserGroup(
                id: group.groupId,
                name: group.groupName,
                imageURL: group.icon,
                users: [],  // APIからユーザー情報は返ってこないため空配列を設定
                password: "" // APIからパスワードは返ってこないため空文字を設定
            )
        }
        #endif
    }
    
    func getGroupMembers(groupId: Int) async throws -> [UserProfile] {
        #if DEBUG
        return try await debugGetGroupMembers(groupId: groupId)
        #else
        let request = GetGroupMembersRequest(groupId: groupId)
        let response = try await apiClient.call(request: request)
        
        return response.member.map { member in
            UserProfile(
                id: member.userId,
                name: member.userName,
                imageURL: member.icon.flatMap { URL(string: $0) }
            )
        }
        #endif
    }
    
    func getGroup(groupId: Int) async throws -> UserGroup {
        #if DEBUG
        return try await debugGetGroup(groupId: groupId)
        #else
        let request = GetGroupRequest(groupId: groupId)
        let response = try await apiClient.call(request: request)
        
        return UserGroup(
            id: groupId,
            name: response.name,
            imageURL: response.icon,
            users: [],  // APIからユーザー情報は返ってこないため空配列を設定
            password: "" // APIからパスワードは返ってこないため空文字を設定
        )
        #endif
    }
}

#if DEBUG
private extension GroupRepository {
    func debugGetUserGroups(userId: Int) async throws -> [UserGroup] {
        return [
            UserGroup(
                id: 1,
                name: "家族",
                imageURL: "house.fill",
                users: [
                    UserProfile(id: 1, name: "父", imageURL: nil),
                    UserProfile(id: 2, name: "母", imageURL: nil),
                    UserProfile(id: 3, name: "兄", imageURL: nil)
                ],
                password: "family2024"
            ),
            UserGroup(
                id: 2,
                name: "友達",
                imageURL: "person.2.fill",
                users: [
                    UserProfile(id: 4, name: "友達A", imageURL: nil),
                    UserProfile(id: 5, name: "友達B", imageURL: nil)
                ],
                password: "friends2024"
            )
        ]
    }
    
    func debugGetGroupMembers(groupId: Int) async throws -> [UserProfile] {
        switch groupId {
        case 1:
            return [
                UserProfile(id: 1, name: "父", imageURL: nil),
                UserProfile(id: 2, name: "母", imageURL: nil),
                UserProfile(id: 3, name: "兄", imageURL: nil)
            ]
        case 2:
            return [
                UserProfile(id: 4, name: "友達A", imageURL: nil),
                UserProfile(id: 5, name: "友達B", imageURL: nil)
            ]
        default:
            return []
        }
    }
    
    func debugGetGroup(groupId: Int) async throws -> UserGroup {
        switch groupId {
        case 1:
            return UserGroup(
                id: 1,
                name: "家族",
                imageURL: "house.fill",
                users: [],
                password: "family2024"
            )
        case 2:
            return UserGroup(
                id: 2,
                name: "友達",
                imageURL: "person.2.fill",
                users: [],
                password: "friends2024"
            )
        default:
            throw NSError(domain: "GroupRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "グループが見つかりません"])
        }
    }
}
#endif
