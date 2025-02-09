import Alamofire

struct GetUserGroupsRequest: RequestProtocol {
    typealias Response = GetUserGroupsResponse
    
    let userId: Int
    
    var path: String {
        return "group/user"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: Parameters? {
        return ["user_id": userId]
    }
} 