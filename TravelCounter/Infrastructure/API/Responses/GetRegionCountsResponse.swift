struct GetRegionCountsResponse: ResponseProtocol {
    let counts: [RegionCount]
}

struct RegionCount: Codable {
    let regionName: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case regionName = "region_name"
        case count
    }
}