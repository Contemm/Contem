import Foundation


protocol CommentProtocol {
    func fetchComments(postId: String) async
    func createComment(postId: String, content: String) async
    func updateComment(postId: String, commentId: String, content: String) async
    func createReply(postId: String, commentId: String, content: String) async
    func deleteComment(postId: String, commentId: String) async
}
