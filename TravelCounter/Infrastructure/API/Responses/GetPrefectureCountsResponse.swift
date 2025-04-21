struct GetPrefectureCountsResponse: ResponseProtocol {
    let counts: [PrefectureCount]
}

struct PrefectureCount: Codable {
    let prefectureName: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case prefectureName = "prefecture_name"
        case count
    }
}