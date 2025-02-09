import Foundation

final class GetMapPostsUseCase {
    private let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol = PostRepository.shared) {
        self.postRepository = postRepository
    }
    
    func execute(prefectureId: String, groupIds: [Int]) async throws -> [Post] {
        return try await postRepository.getMapPosts(prefectureId: prefectureId, groupIds: groupIds)
    }
} 