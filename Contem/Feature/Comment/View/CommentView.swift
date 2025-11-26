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
    
    @State private var editCommentId: String? = nil
    @State private var editingImageUrl: URL? = nil
    
    
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
                            profileImageView(imagePath: comment.user.profileImage, size: 40)
                            
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
                                        // 1. 입력창 및 상태 초기화
                                        text = ""; commentId = nil; replyTartgetUser = nil
                                        selectedImage = nil; selectedImageData = nil
                                        
                                        // 2. 수정 데이터 세팅
                                        self.editCommentId = comment.commentId
                                        
                                        if comment.isImage {
                                            self.editingImageUrl = comment.fullImageUrl
                                            self.text = ""
                                        } else {
                                            self.editingImageUrl = nil
                                            self.text = comment.comment
                                        }
                                        
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
                                    profileImageView(imagePath: reply.user.profileImage, size: 32)
                                    
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
                                                // 1. 초기화
                                                text = ""; commentId = nil; selectedImage = nil; selectedImageData = nil
                                                
                                                // 2. 수정 데이터 세팅
                                                self.editCommentId = reply.commentId
                                                self.replyTartgetUser = comment.user.nickname // 부모 닉네임 태그 표시
                                                
                                                if reply.isImage {
                                                    self.editingImageUrl = reply.fullImageUrl
                                                    self.text = ""
                                                } else {
                                                    self.editingImageUrl = nil
                                                    self.text = reply.comment
                                                }
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
                
                if selectedImageData != nil || editingImageUrl != nil{
                    HStack {
                        ZStack(alignment: .topTrailing) {
                            
                            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else if let url = editingImageUrl  {
                                KFImage(url)
                                    .resizable().scaledToFill()
                                    .frame(width: 60, height: 60).clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                           
                            
                            // 미리보기 삭제 버튼
                            Button {
                                withAnimation {
                                    selectedImage = nil
                                    selectedImageData = nil
                                    editingImageUrl = nil
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.black, .white)
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
                        if editCommentId != nil {
                            HStack(spacing: 4) {
                                Text("수정 중")
                                    .font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                                // 수정 취소 버튼
                                Button {
                                    withAnimation {
                                        editCommentId = nil; text = ""; editingImageUrl = nil; replyTartgetUser = nil
                                    }
                                } label: {
                                    Image(systemName: "xmark").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                                }
                            }
                            .padding(.vertical, 4).padding(.horizontal, 8)
                            .background(Color.orange) // 수정은 주황색 등으로 구분
                            .clipShape(Capsule())
                        }
                        
                        
                        if let nickname = replyTartgetUser {
                            HStack(spacing: 4) {
                                Text("@\(nickname)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.primary0)
                                
                                // 태그 취소 버튼 (수정 모드가 아닐 때만 닫기 가능하도록 하거나, 항상 가능하게 해도 됨)
                                if editCommentId == nil {
                                    Button {
                                        withAnimation { commentId = nil; replyTartgetUser = nil }
                                    } label: {
                                        Image(systemName: "xmark").font(.system(size: 10, weight: .bold)).foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 4).padding(.horizontal, 8)
                            .background(Color.primary100).clipShape(Capsule())
                        }
                        let isImageAttached = (selectedImageData != nil || editingImageUrl != nil)

                        TextField(isImageAttached ? "이미지 전송 시 텍스트 불가" : "댓글을 입력하세요...", text: $text)
                            .font(.body)
                            .autocapitalization(.none)
                            .disabled(isImageAttached)
                        
                        
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
                        if let editId = editCommentId {
                            var contentToSend = text
                            // 텍스트는 비어있는데, 기존 이미지는 살아있는 경우 -> 기존 이미지 경로 전송
                            if contentToSend.isEmpty, let existingUrl = editingImageUrl {
                                contentToSend = existingUrl.path // URL에서 경로만 추출 
                            }
                            
                            viewModel.input.commentUpdateTapped.send((editId, contentToSend, selectedImageData))
                        } else {
                            viewModel.input.commentSendTapped.send((text, commentId, selectedImageData))
                        }
                        
                        // 전송 후 전체 초기화
                        text = ""; commentId = nil; replyTartgetUser = nil
                        selectedImage = nil; selectedImageData = nil
                        editCommentId = nil; editingImageUrl = nil
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
                    editingImageUrl = nil
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
    private func profileImageView(imagePath: String?, size: CGFloat) -> some View {
        if let path = imagePath, !path.isEmpty, let url = URL(string: APIConfig.baseURL + path) {
            KFImage(url)
                .requestModifier(MyImageDownloadRequestModifier())
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding(size * 0.25)
                .frame(width: size, height: size)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
                .foregroundColor(.white)
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
