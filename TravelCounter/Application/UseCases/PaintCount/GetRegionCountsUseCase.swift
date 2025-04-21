class GetRegionCountsUseCase {
    private let repository: PaintCountRepositoryProtocol
    
    init(repository: PaintCountRepositoryProtocol = PaintCountRepository()) {
        self.repository = repository
    }
    
    func execute(groupIds: [Int]) async throws -> [RegionCount] {
        return try await repository.getRegionCounts(groupIds: groupIds)
    }
} 