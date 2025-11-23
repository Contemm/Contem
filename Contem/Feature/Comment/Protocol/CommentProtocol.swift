import Foundation


protocol CommentProtocol {
    func fetchComments(postId: String) async throws -> CommentListDTO
    func createComment(postId: String, content: String) async throws -> CommentDTO
    func updateComment(postId: String, commentId: String, content: String) async throws -> Void
    func createReply(postId: String, commentId: String, content: String) async throws -> CommentDTO
}
