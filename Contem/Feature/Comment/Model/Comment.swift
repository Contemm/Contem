import Foundation


struct CommentList {
    let commentList: [Comment]
    
    init(from dto: CommentListDTO) {
        self.commentList = dto.data.map { Comment(from: $0) }
    }
}

struct Comment {
    let commentId: String
    let comment: String
    let createAt: String
    let user: UserDTO
    let replies: [Comment]?
    
    init(from dto: CommentDTO) {
        self.commentId = dto.commentId
        self.comment = dto.content
        self.createAt = dto.createdAt
        self.user = dto.creator
        self.replies = dto.replies as? [Comment]
    }
}
