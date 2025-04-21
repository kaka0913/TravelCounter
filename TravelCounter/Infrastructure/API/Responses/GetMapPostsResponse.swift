import Foundation

struct MapPost: Codable {
    let postId: Int
    let image: String
    let longitude: Float
    let latitude: Float
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case image
        case longitude
        case latitude
    }
}

struct GetMapPostsResponse: ResponseProtocol {
    let posts: [MapPost]
} 