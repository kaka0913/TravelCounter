import Foundation
import Alamofire

struct CreatePostRequest: RequestProtocol {
    typealias Response = CreatePostResponse
    
    let image: String
    let date: Date
    let comment: String
    let longitude: Float
    let latitude: Float
    let userId: Int
    let prefectureId: String
    let groupIds: [Int]
    
    var path: String {
        return "/post"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: Parameters? {
        return [
            "image": image,
            "date": ISO8601DateFormatter().string(from: date),
            "comment": comment,
            "longitude": longitude,
            "latitude": latitude,
            "user_id": userId,
            "prefecture_id": prefectureId,
            "groups": groupIds.map { ["id": $0] }
        ]
    }
} 