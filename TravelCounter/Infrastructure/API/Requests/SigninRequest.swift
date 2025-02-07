import Foundation
import Alamofire

struct SigninRequest: RequestProtocol {
    typealias Response = AuthResponse
    
    let authId: String
    
    var path: String {
        return "/auth/signin"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return [
            "auth_id": authId
        ]
    }
} 