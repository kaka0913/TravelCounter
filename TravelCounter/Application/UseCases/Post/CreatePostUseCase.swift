import Foundation
import CoreLocation

final class CreatePostUseCase {
    private let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol = PostRepository.shared) {
        self.postRepository = postRepository
    }
    
    func execute(
        image: String,
        comment: String,
        coordinate: CLLocationCoordinate2D,
        userId: Int,
        prefectureId: String,
        groupIds: [Int]
    ) async throws -> Bool {
        return try await postRepository.createPost(
            image: image,
            comment: comment,
            coordinate: coordinate,
            userId: userId,
            prefectureId: prefectureId,
            groupIds: groupIds
        )
    }
} 