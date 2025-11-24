import SwiftUI
import Combine

struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel
    @State private var text: String = ""
    @State private var commentId: String?
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("댓글")
                .font(.titleSmall)
                .bold()
                .padding(.vertical, CGFloat.spacing16)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: CGFloat.spacing16) {
                    ForEach(viewModel.output.commentList, id: \.commentId) { comment in
                        HStack(alignment: .top, spacing: CGFloat.spacing12) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: CGFloat.spacing4) {
                                HStack(alignment: .center, spacing: CGFloat.spacing4) {
                                    Text(comment.user.nickname)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text(comment.createCommentDate)
                                        .font(.captionRegular)
                                }
                                
                                Text(comment.comment)
                                    .font(.system(size: 14))
                                    .lineLimit(nil)
                                
                                HStack(spacing: CGFloat.spacing4) {
                                    Button {
                                        self.commentId = comment.commentId
                                    } label: {
                                        Text("답글 달기")
                                    }
                                    Spacer().frame(width: CGFloat.spacing8)
                                    Button {
                                        viewModel.input.deleteCommentTapped.send(comment.commentId)
                                    } label: {
                                        Text("삭제")
                                    }
                                    Spacer().frame(width: 2)
                                    Button {
                                        viewModel.input.deleteCommentTapped.send(comment.commentId)
                                    } label: {
                                        Text("수정")
                                    }
                                }
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                            }
                        }
                        .padding(.horizontal, CGFloat.spacing16)
                        
                        
                        // 대댓글
                        VStack {
                            ForEach(comment.replies ?? [], id: \.commentId) { reply in
                                HStack(alignment: .top) {
                                    // 대댓글 표시 아이콘 (ㄴ 모양 등)
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 32, height: 32)
                                    
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
                                        HStack {
                                            Button("삭제") {
                                                viewModel.input.deleteCommentTapped.send(reply.commentId)
                                            }
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                            
                                            Button("수정") {
                                                print("수정 하기")
                                            }
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                        }
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }.padding(.leading, 72)
                    }
                }
            }
            
            VStack {
                Divider()
                HStack {
                    TextField("댓글을 입력하세요...", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    Button {
                        viewModel.input.commentSendTapped.send((text, commentId))
                        text = ""
                        commentId = nil
                    } label: {
                        Image(systemName: "paperplane")
                            .foregroundStyle(Color.primary100)
//                        Text("전송")
                    }
                    .disabled(text.isEmpty)
                }
                .padding(.horizontal)
                .padding(.vertical, 8) // 입력창 위아래 여백
                // 배경색을 지정해야 키보드가 올라올 때 뒤의 콘텐츠가 비치지 않습니다.
                .background(Color(UIColor.systemBackground))
            }
        }.onAppear {
            viewModel.input.viewOnAppear.send()
        }
    }
}

