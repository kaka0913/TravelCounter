class PaintCountRepository: PaintCountRepositoryProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func getPrefectureCounts(groupIds: [Int]) async throws -> [PrefectureCount] {
        #if DEBUG
        return try await debugGetPrefectureCounts(groupIds: groupIds)
        #else
        let request = GetPrefectureCountsRequest(groupIds: groupIds)
        let response = try await apiClient.call(request: request)
        return response.counts
        #endif
    }
    
    func getRegionCounts(groupIds: [Int]) async throws -> [RegionCount] {
        #if DEBUG
        return try await debugGetRegionCounts(groupIds: groupIds)
        #else
        let request = GetRegionCountsRequest(groupIds: groupIds)
        let response = try await apiClient.call(request: request)
        return response.counts
        #endif
    }
}

#if DEBUG
private extension PaintCountRepository {
    func debugGetPrefectureCounts(groupIds: [Int]) async throws -> [PrefectureCount] {
        // ユーザーごとの都道府県訪問回数のモックデータ
        let mockCounts = [
            PrefectureCount(prefectureName: "東京都", count: 5),
            PrefectureCount(prefectureName: "大阪府", count: 3),
            PrefectureCount(prefectureName: "京都府", count: 2),
            PrefectureCount(prefectureName: "神奈川県", count: 2),
            PrefectureCount(prefectureName: "宮城県", count: 1)
        ]
        return mockCounts
    }
    
    func debugGetRegionCounts(groupIds: [Int]) async throws -> [RegionCount] {
        // ユーザーごとの地域訪問回数のモックデータ
        let mockCounts = [
            RegionCount(regionName: "北海道", count: 2),
            RegionCount(regionName: "東北", count: 3),
            RegionCount(regionName: "関東", count: 10),
            RegionCount(regionName: "中部", count: 2),
            RegionCount(regionName: "近畿", count: 5),
            RegionCount(regionName: "中国", count: 0),
            RegionCount(regionName: "四国", count: 0),
            RegionCount(regionName: "九州", count: 0)
        ]
        return mockCounts
    }
} 
#endif
