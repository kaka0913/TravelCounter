protocol PaintCountRepositoryProtocol {
    func getPrefectureCounts(groupIds: [Int]) async throws -> [PrefectureCount]
    func getRegionCounts(groupIds: [Int]) async throws -> [RegionCount]
} 