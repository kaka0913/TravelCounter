import Foundation
import Alamofire

struct GetProfileRequest: RequestProtocol {
    typealias Response = ProfileResponse
    
    let userId: Int
    
    var path: String {
        return "/auth/profile"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return [
            "user_id": userId
        ]
    }
} 