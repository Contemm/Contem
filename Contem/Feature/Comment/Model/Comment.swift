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
    private let createdAt: Date
    let user: UserDTO
    let replies: [Comment]?
    var createCommentDate: String {
        let diff = Date().timeIntervalSince(self.createdAt)
        
        switch diff {
        case 0..<60:
            return "방금 전"
        case 60..<3600:
            return "\(Int(diff / 60))분 전"
        case 3600..<86400: // 24시간 미만
            return "\(Int(diff / 3600))시간 전"
        case 86400..<(86400 * 7): // 7일 미만
            return "\(Int(diff / 86400))일 전"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 M월 d일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: self.createdAt)
        }
    }
    
    init(from dto: CommentDTO) {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.commentId = dto.commentId
        self.comment = dto.content
        self.createdAt = isoFormatter.date(from: dto.createdAt) ?? Date()
        self.user = dto.creator
        self.replies = dto.replies?.map { Comment(from: $0) } ?? []
    }
    
    
}
