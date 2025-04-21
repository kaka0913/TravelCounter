import Alamofire

struct GetPrefectureCountsRequest: RequestProtocol {
    typealias Response = GetPrefectureCountsResponse
    
    let groupIds: [Int]
    
    var path: String {
        return "paint/prefectures"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: Parameters? {
        return ["groups": groupIds.map { ["id": $0] }]
    }
} 