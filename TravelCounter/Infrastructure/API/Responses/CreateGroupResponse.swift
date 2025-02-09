struct CreateGroupResponse: ResponseProtocol {
    let groupId: Int
    
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
    }
} 