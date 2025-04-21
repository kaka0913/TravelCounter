import Foundation
import Alamofire

struct GetPostDetailRequest: RequestProtocol {
    typealias Response = GetPostDetailResponse
    
    let postId: Int
    
    var path: String {
        return "/post"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return [
            "post_id": postId
        ]
    }
} 