import Alamofire

struct JoinGroupRequest: RequestProtocol {
    typealias Response = JoinGroupResponse
    
    let userId: Int
    let groupId: Int
    let password: String
    
    var path: String {
        return "group/member"
    }
    
    var method: HTTPMethod {
        return .put
    }
    
    var parameters: Parameters? {
        return [
            "user_id": userId,
            "group_id": groupId,
            "password": password
        ]
    }
} 