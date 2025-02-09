import Alamofire

struct GetGroupMembersRequest: RequestProtocol {
    typealias Response = GetGroupMembersResponse
    
    let groupId: Int
    
    var path: String {
        return "group/member"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return ["group_id": groupId]
    }
} 
