import SwiftUI
import Combine

struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyHStack {
                    ForEach(viewModel.output.commentList, id: \.commentId) { comment in
                        Text(comment.user.nickname)
                        Text(comment.comment)
                        Text(comment.createCommentDate)
                    }
                }
            }
        }.onAppear {
            viewModel.input.viewOnAppear.send()
        }
    }
}

