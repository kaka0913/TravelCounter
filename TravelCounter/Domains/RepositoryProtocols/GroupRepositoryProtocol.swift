protocol GroupRepositoryProtocol {
    func getUserGroups(userId: Int) async throws -> [UserGroup]
    func getGroupMembers(groupId: Int) async throws -> [UserProfile]
    func getGroup(groupId: Int) async throws -> UserGroup
} 