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
        let commentSendTapped = PassthroughSubject<(String, String?), Never>()
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
            .sink { owner, commentInfo in
                let (comment, commentId) = commentInfo
                            
                Task {
                    if let commentId = commentId {
                        // 대댓글 작성
                        await owner.createReply(postId: owner.postId, commentId: commentId, content: comment)
                    } else {
                        // 댓글 작성
                        await owner.createComment(postId: owner.postId, content: comment)
                    }
                    
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
    // 댓글 조회
    func fetchComments(postId: String) async {
        do {
            let router = CommentPostRequest.fetch(postId: postId)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentListDTO.self)
            let comments = CommentList(from: result)
            await MainActor.run {
                output.commentList = comments.commentList
            }
            
        } catch {
            
        }
        
    }
    
    // 댓글 작성
    func createComment(postId: String, content: String) async {
        do {
            let router = CommentPostRequest.create(postId: postId, content: content)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentDTO.self)
            let comment = Comment(from: result)
            await MainActor.run {
                output.commentList.append(comment)
            }
        } catch {
            
        }
    }
    
    // 댓글&대댓글 수정
    func updateComment(postId: String, commentId: String, content: String) async {
        do {
            let router = CommentPostRequest.update(postId: postId, commentId: commentId, content: content)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentDTO.self)
            let modifiedComment = Comment(from: result)
            
            await MainActor.run {
                if let index = output.commentList.firstIndex(where: { $0.commentId == commentId }) {
                    output.commentList[index] = modifiedComment
                }
            }
        } catch {
            
        }
    }
    
    // 대댓글 작성
    func createReply(postId: String, commentId: String, content: String) async {
        do {
            let router = CommentPostRequest.createReply(postId: postId, commentId: commentId, content: content)
            let result = try await NetworkService.shared.callRequest(router: router, type: CommentDTO.self)
            let reply = Comment(from: result)
            await MainActor.run {
                if let index = output.commentList.firstIndex(where: { $0.commentId == commentId }) {
                    var parentComment = output.commentList[index]
                    var currentReplies = parentComment.replies ?? []
                    currentReplies.append(reply)
                    parentComment.replies = currentReplies
                    output.commentList[index] = parentComment
                }
            }
        } catch {
            
        }
    }
    
    // 댓글&대댓글 삭제
    func deleteComment(postId: String, commentId: String) async {
        do {
            let router = CommentPostRequest.delete(postId: postId, commentId: commentId)
            try await NetworkService.shared.callRequest(router: router, type: EmptyResponseDTO.self)
            await MainActor.run {
                if let index = output.commentList.firstIndex(where: { $0.commentId == commentId }) {
                    output.commentList.remove(at: index)
                    return
                }
                
                if let parentIndex = output.commentList.firstIndex(where: { parent in
                    parent.replies?.contains(where: { $0.commentId == commentId }) == true
                }) {
                    
                    output.commentList[parentIndex].replies?.removeAll { $0.commentId == commentId }
                }
                
            }
        } catch  {
            print("실패 \(error)")
        }
    }
}
