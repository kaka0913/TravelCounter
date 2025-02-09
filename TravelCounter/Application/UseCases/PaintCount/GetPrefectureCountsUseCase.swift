class GetPrefectureCountsUseCase {
    private let repository: PaintCountRepositoryProtocol
    
    init(repository: PaintCountRepositoryProtocol = PaintCountRepository()) {
        self.repository = repository
    }
    
    func execute(groupIds: [Int]) async throws -> [PrefectureCount] {
        return try await repository.getPrefectureCounts(groupIds: groupIds)
    }
}
