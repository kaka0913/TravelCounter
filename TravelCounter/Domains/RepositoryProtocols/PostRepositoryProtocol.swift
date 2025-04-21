import Foundation
import CoreLocation

protocol PostRepositoryProtocol {
    func createPost(
        image: String,
        comment: String,
        coordinate: CLLocationCoordinate2D,
        userId: Int,
        prefectureId: String,
        groupIds: [Int]
    ) async throws -> Bool
    
    func getMapPosts(prefectureId: String, groupIds: [Int]) async throws -> [Post]
    func getPostDetail(postId: Int) async throws -> Post
} 