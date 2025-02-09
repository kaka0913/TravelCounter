class CreateGroupUseCase {
    private let repository: GroupRepositoryProtocol
    
    init(repository: GroupRepositoryProtocol = GroupRepository()) {
        self.repository = repository
    }
    
    func execute(name: String, icon: String, password: String, authorId: Int) async throws -> Int {
        return try await repository.createGroup(
            name: name,
            icon: icon,
            password: password,
            authorId: authorId
        )
    }
} 