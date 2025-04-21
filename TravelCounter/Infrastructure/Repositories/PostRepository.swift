import Foundation
import CoreLocation

class PostRepository: PostRepositoryProtocol {
    private let apiClient = APIClient.shared
    static let shared = PostRepository()
    
    func createPost(
        image: String,
        comment: String,
        coordinate: CLLocationCoordinate2D,
        userId: Int,
        prefectureId: String,
        groupIds: [Int]
    ) async throws -> Bool {
        #if DEBUG
        return try await Self.getMockCreatePost()
        #else
        let request = CreatePostRequest(
            image: image,
            date: Date(),
            comment: comment,
            longitude: Float(coordinate.longitude),
            latitude: Float(coordinate.latitude),
            userId: userId,
            prefectureId: prefectureId,
            groupIds: groupIds
        )
        let response = try await apiClient.call(request: request)
        return response.isSuccess
        #endif
    }
    
    func getMapPosts(prefectureId: String, groupIds: [Int]) async throws -> [Post] {
        #if DEBUG
        return try await Self.getMockMapPosts()
        #else
        let request = GetMapPostsRequest(prefectureId: prefectureId, groupIds: groupIds)
        let response = try await apiClient.call(request: request)
        return response.posts.map { mapPost in
            Post(
                id: mapPost.postId,
                userId: 0,
                userName: "",
                image: mapPost.image,
                comment: "",
                date: Date(),
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(mapPost.latitude),
                    longitude: Double(mapPost.longitude)
                ),
                prefectureId: prefectureId,
                groupIds: groupIds
            )
        }
        #endif
    }
    
    func getPostDetail(postId: Int) async throws -> Post {
        #if DEBUG
        return try await Self.getMockPostDetail(postId: postId)
        #else
        let request = GetPostDetailRequest(postId: postId)
        let response = try await apiClient.call(request: request)
        return Post(
            id: postId,
            userId: response.userId,
            userName: response.userName,
            image: response.image,
            comment: response.comment,
            date: response.date,
            coordinate: CLLocationCoordinate2D(),
            prefectureId: "",
            groupIds: []
        )
        #endif
    }
}

// MARK: - Mock Data
extension PostRepository {
    static func getMockCreatePost() async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    static func getMockMapPosts() async throws -> [Post] {
        return [
            Post(
                id: 1,
                userId: 1,
                userName: "テストユーザー1",
                image: "Painteer",
                comment: "東京タワーに行ってきました！",
                date: Date(),
                coordinate: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
                prefectureId: "tokyo",
                groupIds: [1]
            ),
            Post(
                id: 2,
                userId: 2,
                userName: "テストユーザー2",
                image: "Painteer",
                comment: "スカイツリーの夜景が綺麗でした",
                date: Date(),
                coordinate: CLLocationCoordinate2D(latitude: 35.7100, longitude: 139.8107),
                prefectureId: "tokyo",
                groupIds: [1, 2]
            )
        ]
    }
    
    static func getMockPostDetail(postId: Int) async throws -> Post {
        return Post(
            id: postId,
            userId: 1,
            userName: "テストユーザー1",
            image: "Painteer",
            comment: "東京タワーに行ってきました！",
            date: Date(),
            coordinate: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
            prefectureId: "tokyo",
            groupIds: [1]
        )
    }
} 