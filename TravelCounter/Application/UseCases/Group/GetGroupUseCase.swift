class GetGroupUseCase {
    private let repository: GroupRepositoryProtocol
    
    init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    func execute(groupId: Int) async throws -> UserGroup {
        return try await repository.getGroup(groupId: groupId)
    }
} 