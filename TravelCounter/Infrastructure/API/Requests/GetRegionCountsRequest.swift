import Alamofire

struct GetRegionCountsRequest: RequestProtocol {
    typealias Response = GetRegionCountsResponse
    
    let groupIds: [Int]
    
    var path: String {
        return "paint/region"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: Parameters? {
        return ["groups": groupIds.map { ["id": $0] }]
    }
} 