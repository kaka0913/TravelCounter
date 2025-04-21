import Foundation

struct ProfileResponse: ResponseProtocol {
    let userName: String
    let icon: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case icon
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
} 