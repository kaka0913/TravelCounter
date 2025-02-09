import Foundation
import Alamofire

struct GetMapPostsRequest: RequestProtocol {
    typealias Response = GetMapPostsResponse
    
    let prefectureId: String
    let groupIds: [Int]
    
    var path: String {
        return "/post/map"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return [
            "prefecture_id": prefectureId,
            "groups": groupIds.map { ["id": $0] }
        ]
    }
} 