import Foundation

enum CommentPostRequest: TargetTypeProtocol {
    // MARK: - Case
    case fetch(postId: String)
    case create(postId: String, content: String)
    case update(postId: String ,commentId: String, content: String)
    case delete(postId: String, commentId: String)
    case createReply(postId: String, commentId: String, content: String)
    
    
    // MARK: - Path
    var path: String {
        switch self {
        // 댓글 조회 & 댓글 작성
        case .fetch(let postId), .create(let postId, _):
            return "/posts/\(postId)/comments"
        // 수정 & 삭제
        case .update(let postId, let commentId, _),
                .delete(let postId, let commentId):
            return "/v1/posts/\(postId)/comments/\(commentId)"
        // 대댓글 작성
        case .createReply(let postId, let commentId, _):
            return "/v1/posts/\(postId)/comments/\(commentId)/replies"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .create, .createReply:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }
    
    // MARK: - Headers
    var headers: [String : String] {
        return [
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    // MARK: - Parameters
    var parameters: [String : Any] {
        switch self {
        case .fetch, .delete:
            return [:]
        case .create(_, let content),
                .update(_, _, let content),
                .createReply(_, _, let content):
            return [
                "content": content
            ]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        return nil
    }
}
