import Foundation

final class GetPostDetailUseCase {
    private let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol = PostRepository.shared) {
        self.postRepository = postRepository
    }
    
    func execute(postId: Int) async throws -> Post {
        return try await postRepository.getPostDetail(postId: postId)
    }
} 