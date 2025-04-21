class GetUserGroupsUseCase {
    private let repository: GroupRepositoryProtocol
    
    init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    func execute(userId: Int) async throws -> [UserGroup] {
        return try await repository.getUserGroups(userId: userId)
    }
} 