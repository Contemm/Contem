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
        let viewOnAppear = PassthroughSubject<Void, Never>()
        let commentSendTapped = PassthroughSubject<String, Never>()
        let deleteCommentTapped = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var commentList: [Comment] = []
    }
    
    init(coordinator: AppCoordinator, postId: String) {
        self.coordinator = coordinator
        self.postId = postId
        transform()
    }
    
    func transform() {
        input.viewOnAppear
            .withUnretained(self)
            .sink { owner, _ in
                Task {
                    await owner.fetchComments(postId: owner.postId)
                }
            }.store(in: &cancellables)
        
        input.commentSendTapped
            .withUnretained(self)
            .sink { owner, comment in
                print(comment)
                Task {
                    await owner.createComment(postId: owner.postId, content: comment)
                }
            }.store(in: &cancellables)
        
        input.deleteCommentTapped
            .withUnretained(self)
            .sink { owner, commentId in
                print("게시글 아이디 : \(owner.postId)")
                Task {
                    await owner.deleteComment(postId: owner.postId, commentId: commentId)
                }
            }.store(in: &cancellables)
    }
}


extension CommentViewModel {
    func fetchComments(postId: String) async {
        do {
            let router = CommentPostRequest.fetch(postId: postId)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentListDTO.self)
            let comments = CommentList(from: result)
            output.commentList = comments.commentList
        } catch {
            
        }
        
    }
    
    func createComment(postId: String, content: String) async {
        do {
            let router = CommentPostRequest.create(postId: postId, content: content)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentDTO.self)
            let comment = Comment(from: result)
            output.commentList.insert(comment, at: 0)
        } catch {
            
        }
    }
    
    func updateComment(postId: String, commentId: String, content: String) async {
        
    }
    
    func createReply(postId: String, commentId: String, content: String) async {
        
    }
    
    func deleteComment(postId: String, commentId: String) async {
        do {
            let router = CommentPostRequest.delete(postId: postId, commentId: commentId)
            try await NetworkService.shared.callRequest(router: router)
            await MainActor.run {
                output.commentList.removeAll { $0.commentId == commentId }
            }
        } catch  {
            print("실패 \(error)")
        }
    }
}
