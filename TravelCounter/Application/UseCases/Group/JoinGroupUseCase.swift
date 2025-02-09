class JoinGroupUseCase {
    private let repository: GroupRepositoryProtocol
    
    init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    func execute(userId: Int, groupId: Int, password: String) async throws -> Int {
        return try await repository.joinGroup(
            userId: userId,
            groupId: groupId,
            password: password
        )
    }
} 