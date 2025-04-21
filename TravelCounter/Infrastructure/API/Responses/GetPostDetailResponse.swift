import Foundation

struct GetPostDetailResponse: ResponseProtocol {
    let userName: String
    let userId: Int
    let image: String
    let comment: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userId = "user_id"
        case image
        case comment
        case date
    }
} 