import Foundation
import Combine


@MainActor
final class CommentViewModel: ViewModelType, CommentProtocol {
    
    
    var cancellables = Set<AnyCancellable>()
    private weak var coordinator: AppCoordinator?
    private let postId: String
    
    var input = Input()
    
    @Published
    var output = Output()
    
    struct Input {
        let viewOnAppear = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        
    }
    
    init(coordinator: AppCoordinator, postId: String) {
        self.coordinator = coordinator
        self.postId = postId
        transform()
    }
    
    func transform() {
        input.viewOnAppear
            .withUnretained(self)
            .sink { owner, postId in
                Task {
                    await owner.fetchComments(postId: postId)
                }
            }.store(in: &cancellables)
    }
}


extension CommentViewModel {
    func fetchComments(postId: String) async {
        do {
            let router = CommentPostRequest.fetch(postId: postId)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentListDTO.self)
            dump(result)
        } catch {
            
        }
        
    }
    
    func createComment(postId: String, content: String) async {
        
    }
    
    func updateComment(postId: String, commentId: String, content: String) async {
        
    }
    
    func createReply(postId: String, commentId: String, content: String) async {
        
    }
}
