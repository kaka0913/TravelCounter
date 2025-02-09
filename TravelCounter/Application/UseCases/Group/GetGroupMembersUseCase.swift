class GetGroupMembersUseCase {
    private let repository: GroupRepositoryProtocol
    
    init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    func execute(groupId: Int) async throws -> [UserProfile] {
        return try await repository.getGroupMembers(groupId: groupId)
    }
} 