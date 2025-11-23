import Foundation
import Combine


@MainActor
final class CommentViewModel: ViewModelType, CommentProtocol {
    
    
    var cancellables = Set<AnyCancellable>()
    private weak var coordinator: AppCoordinator?
    
    var input = Input()
    
    @Published
    var output = Output()
    
    struct Input {
        let viewOnAppear = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        transform()
    }
    
    func transform() {
        input.viewOnAppear
            .withUnretained(self)
            .sink { owner, postId in
                owner.fetchComments(postId: postId)
            }.store(in: &cancellables)
    }
}


extension CommentViewModel {
    func fetchComments(postId: String) async throws -> CommentListDTO {
        <#code#>
    }
    
    func createComment(postId: String, content: String) async throws -> CommentDTO {
        <#code#>
    }
    
    func updateComment(postId: String, commentId: String, content: String) async throws {
        <#code#>
    }
    
    func createReply(postId: String, commentId: String, content: String) async throws -> CommentDTO {
        <#code#>
    }
}
