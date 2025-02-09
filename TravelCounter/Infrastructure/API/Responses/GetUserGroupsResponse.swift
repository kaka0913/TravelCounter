struct GetUserGroupsResponse: ResponseProtocol {
    let groups: [GroupResponse]
    
    struct GroupResponse: Decodable {
        let groupId: Int
        let groupName: String
        let icon: String
        
        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case groupName = "group_name"
            case icon
        }
    }
} 