import Foundation


struct CommentDTO: Codable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserDTO
    let replies: [CommentDTO]?
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id" 
        case content
        case createdAt
        case creator
        case replies
    }
}
