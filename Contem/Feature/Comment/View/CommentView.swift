import SwiftUI
import Combine
import PhotosUI
import Kingfisher

struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel
    
    @State private var text: String = ""
    @State private var commentId: String?
    @State private var replyTartgetUser: String?
    
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
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
                                
                                
                                commentContentView(comment: comment)
                                
                                HStack(spacing: CGFloat.spacing4) {
                                    Button {
                                        self.commentId = comment.commentId
                                        self.replyTartgetUser = comment.user.nickname
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
                                .foregroundColor(Color.gray500)
                                .padding(.top, 2)
                            }
                        }
                        .padding(.horizontal, CGFloat.spacing16)
                        
                        
                        // 대댓글
                        VStack {
                            ForEach(comment.replies ?? [], id: \.commentId) { reply in
                                HStack(alignment: .top) {
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
                                        
                                        commentContentView(comment: reply)
                                        
                                        HStack {
                                            Button("삭제") {
                                                viewModel.input.deleteCommentTapped.send(reply.commentId)
                                            }
                                            .font(.caption2)
                                            .foregroundColor(Color.gray500)
                                            
                                            Button("수정") {
                                                print("수정 하기")
                                            }
                                            .font(.caption2)
                                            .foregroundColor(Color.gray500)
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
                
                if let data = selectedImageData, let uiImage = UIImage(data: data) {
                    HStack {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            // 미리보기 삭제 버튼
                            Button {
                                withAnimation {
                                    selectedImage = nil
                                    selectedImageData = nil
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.black, .white) // 검은 배경, 흰 X
                                    .font(.system(size: 16))
                            }
                            .offset(x: 6, y: -6)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                
                
                HStack(alignment: .center)  {
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: CGFloat.spacing28, height: CGFloat.spacing28)
                            .foregroundStyle(Color.primary100)
                    }
                    HStack {
                        // 태크
                        if let nickname = replyTartgetUser, commentId != nil {
                            HStack(spacing: 4) {
                                Text("@\(nickname)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.primary0)
                                
                                // 태그 취소 버튼
                                Button {
                                    withAnimation {
                                        self.commentId = nil
                                        self.replyTartgetUser = nil
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, CGFloat.spacing4)
                            .padding(.horizontal, CGFloat.spacing8)
                            .background(Color.primary100) // 태그 배경색
                            .clipShape(Capsule())
                        }
                        
                        TextField(selectedImage == nil ? "댓글을 입력하세요..." : "아미지 전송 시 텍스트는 입력할 수 없습니다.", text: $text)
                            .font(.bodyMedium)
                            .autocapitalization(.none)
                            .disabled(selectedImage != nil)
                        
                        
                    }
                    .frame(height: CGFloat.spacing28)
                    .padding(.horizontal, CGFloat.spacing12)
                    .padding(.vertical, CGFloat.spacing4)
                    .background(
                        Capsule()
                            .fill(Color.gray50)
                    )
                    
                    // 전송 버튼
                    Button {
                        viewModel.input.commentSendTapped.send((text, commentId, selectedImageData))
                        
                        text = ""
                        commentId = nil
                        selectedImage = nil
                        selectedImageData = nil
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color.primary100)
                    }.disabled(text.isEmpty && selectedImageData == nil)
                }
                .padding(.horizontal, CGFloat.spacing16)
                .padding(.vertical, CGFloat.spacing12)
            }.onAppear {
                viewModel.input.viewOnAppear.send()
            }.onChange(of: selectedImage) { newItem in
                if newItem != nil {
                    text = ""
                }
                
                Task {
                    guard let _ = newItem else { return }
                    
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        await MainActor.run {
                            self.selectedImageData = data
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func commentContentView(comment: Comment) -> some View {
        if comment.isImage {
            if let url = comment.fullImageUrl {
                KFImage(url)
                    .requestModifier(MyImageDownloadRequestModifier())
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 220, maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.vertical, 4)
            }
        } else {
            Text(comment.comment)
                .font(.bodyMedium)
                .lineLimit(nil)
        }
    }
    
}
