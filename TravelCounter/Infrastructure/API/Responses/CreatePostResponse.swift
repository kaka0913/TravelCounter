import Foundation

struct CreatePostResponse: ResponseProtocol {
    let isSuccess: Bool
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
    }
} 