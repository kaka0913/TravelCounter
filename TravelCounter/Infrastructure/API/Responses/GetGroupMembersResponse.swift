struct GetGroupMembersResponse: ResponseProtocol {
    let member: [MemberResponse]
    
    struct MemberResponse: Decodable {
        let userId: Int
        let userName: String
        let icon: String?
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case userName = "user_name"
            case icon
        }
    }
} 