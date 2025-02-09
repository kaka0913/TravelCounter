protocol GroupRepositoryProtocol {
    func getUserGroups(userId: Int) async throws -> [UserGroup]
    func getGroupMembers(groupId: Int) async throws -> [UserProfile]
    func getGroup(groupId: Int) async throws -> UserGroup
    func createGroup(name: String, icon: String, password: String, authorId: Int) async throws -> Int
    func joinGroup(userId: Int, groupId: Int, password: String) async throws -> Int
} 