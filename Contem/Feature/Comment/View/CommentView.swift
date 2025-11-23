import SwiftUI
import Combine

struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel
    @State private var text: String = ""
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("댓글을 입력하세요...", text: $text)
                    .textFieldStyle(.roundedBorder) // 보기 좋게 테두리 스타일 적용
                    .autocapitalization(.none)
                
                Button {
                    viewModel.input.commentSendTapped.send(text)
                    
                    // 전송 후 입력창 비우기
                    text = ""
                } label: {
                    Text("전송")
                }
                .disabled(text.isEmpty) //
            }
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.output.commentList, id: \.commentId) { comment in
                        Divider()
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

