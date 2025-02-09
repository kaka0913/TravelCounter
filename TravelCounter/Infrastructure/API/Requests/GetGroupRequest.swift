import Alamofire

struct GetGroupRequest: RequestProtocol {
    typealias Response = GetGroupResponse
    
    let groupId: Int
    
    var path: String {
        return "group"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: Parameters? {
        return ["group_id": groupId]
    }
} 