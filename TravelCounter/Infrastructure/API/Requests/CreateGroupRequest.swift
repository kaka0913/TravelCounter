import Alamofire

struct CreateGroupRequest: RequestProtocol {
    typealias Response = CreateGroupResponse
    
    let groupName: String
    let icon: String
    let password: String
    let authorId: Int
    
    var path: String {
        return "group"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: Parameters? {
        return [
            "group_name": groupName,
            "icon": icon,
            "password": password,
            "author_id": authorId
        ]
    }
} 