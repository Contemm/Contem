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
                    viewModel.input.commentSendTapped.send((text, nil))
                    
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
                        Button("삭제") {
                            viewModel.input.deleteCommentTapped.send(comment.commentId)
                        }
                        Button("대댓글 달기") {
                            print(comment.commentId)
                        }
                        LazyVStack {
                            ForEach(viewModel.output.replyList, id: \.commentId) { reply in
                                HStack(alignment: .top) {
                                    // 대댓글 표시 아이콘 (ㄴ 모양 등)
                                    Image(systemName: "arrow.turn.down.right")
                                        .foregroundColor(.gray)
                                        .frame(width: 20, height: 20)
                                        .padding(.top, 4)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(reply.user.nickname)
                                                .font(.system(size: 13, weight: .semibold))
                                            Text(reply.createCommentDate)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Text(reply.comment)
                                            .font(.system(size: 13))
                                            .foregroundColor(.primary.opacity(0.9))
                                        
                                        // 대댓글 삭제 버튼 등 필요하다면 추가
                                        Button("삭제") {
                                            viewModel.input.deleteCommentTapped.send(reply.commentId)
                                        }
                                        .font(.caption2)
                                        .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.leading, 10) // 내부 내용 여백
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.05)) // 대댓글 배경색을 연하게 깔아줌
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }.onAppear {
            viewModel.input.viewOnAppear.send()
        }
    }
}

