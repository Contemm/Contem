//
//  ChattingView.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import SwiftUI
import Combine
import RealmSwift
import Kingfisher
import PhotosUI

// 이미지 프리뷰를 위한 Identifiable 래퍼
struct IdentifiableImageData: Identifiable, Equatable { // Equatable 추가
    let id = UUID() // Truly unique ID for the IdentifiableImageData struct itself
    let data: Data
    let photosPickerItem: PhotosPickerItem // 원본 PhotosPickerItem 자체를 저장
    
    // Equatable 구현 (Data 비교는 오버헤드가 크므로 id만 비교)
    static func == (lhs: IdentifiableImageData, rhs: IdentifiableImageData) -> Bool {
        lhs.id == rhs.id
    }
}

struct ChattingView: View {
    @ObservedObject private var viewModel: ChattingViewModel
    
    @State private var scrollWorkItem: DispatchWorkItem?
    
    init(viewModel: ChattingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            messageListView
            MessageInputView(viewModel: viewModel)
        }
        .navigationTitle(viewModel.output.opponentNickname ?? "채팅")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.input.appear.send(())
        }
        .alert(isPresented: .constant(viewModel.output.error != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.output.error?.localizedDescription ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(Color("gray100"))
    }
    
    private var messageListView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                LazyVStack(spacing: 16) {
                    ChatHeaderView(
                        nickname: viewModel.output.opponentNickname,
                        profileImage: viewModel.output.opponentProfileImage
                    )
                    
                    if let messages = viewModel.output.messages {
                        ForEach(messages) { message in
                            MessageRowView(
                                message: message,
                                isMyMessage: message.sender?.userId == viewModel.output.currentUserId,
                                onImageLoaded: {
                                    // 이미지가 로드되면 항상 디바운스 스크롤 호출
                                    debounceScroll(proxy: scrollViewProxy)
                                }
                            )
                            .id(message.id)
                        }
                    } else {
                        ProgressView()
                    }
                    
                    // 하단 패딩을 위한 Spacer 추가 (높이 1로 설정)
                    Spacer().frame(height: 1).id("bottom-content-padding")
                }
                .padding(.horizontal)
                .padding(.top)
                .onAppear {
                    // 뷰가 나타날 때, 컨텐츠가 있을 수 있으므로 디바운스 스크롤 호출
                    debounceScroll(proxy: scrollViewProxy)
                }
                .onChange(of: viewModel.output.messages?.last?.id, perform: { newLastId in
                    // 새 메시지가 도착했을 때
                    if let lastMessage = viewModel.output.messages?.last, lastMessage.id == newLastId {
                        if lastMessage.files.isEmpty {
                            // 새 메시지에 이미지가 없으면 즉시 스크롤
                            withAnimation {
                                scrollToBottom(proxy: scrollViewProxy)
                            }
                        } else {
                            // 새 메시지에 이미지가 있으면, onImageLoaded가 처리하도록 디바운스 스크롤 호출
                            debounceScroll(proxy: scrollViewProxy)
                        }
                    } else {
                        // 메시지가 없거나 lastMessage.id가 newLastId와 다를 경우 (e.g., 메시지 삭제 시)
                        // 이 경우에도 스크롤 위치를 조정해야 할 수 있음.
                        // 일단은 debounceScroll을 호출하여 안전하게 처리
                        debounceScroll(proxy: scrollViewProxy)
                    }
                })
            }
        }
        .background(.white)
    }
    
    // 스크롤 대상을 변경
    private func scrollToBottom(proxy: ScrollViewProxy) {
        // 맨 아래 패딩 Spacer의 ID를 타겟으로 스크롤
        proxy.scrollTo("bottom-content-padding", anchor: .bottom)
    }

    private func debounceScroll(proxy: ScrollViewProxy) {
        self.scrollWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            withAnimation {
                self.scrollToBottom(proxy: proxy)
            }
        }
        
        self.scrollWorkItem = workItem
        // 딜레이를 0.5초로 늘려 이미지 로딩 시간을 더 확보
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

// 추출된 개별 이미지 미리보기 뷰 (삭제 버튼 로직 제거)
private struct ImagePreviewItemView: View {
    let identifiableImage: IdentifiableImageData
    
    var body: some View {
        if let uiImage = UIImage(data: identifiableImage.data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8)) // Image 자체에 clipShape 적용
        }
    }
}

private struct MessageInputView: View {
    @ObservedObject var viewModel: ChattingViewModel
    @State private var messageText: String = ""
    @State private var selectedImages: [PhotosPickerItem] = [] // PhotosPicker용 원본 아이템
    @State private var previewImages: [IdentifiableImageData] = [] // 미리보기용 Identifiable 이미지 데이터
    @State private var imagesDataToSend: [Data] = [] // 전송용 Data 배열
    
    var body: some View {
        VStack(spacing: 0) {
            imagePreviewSection // extracted computed property
            inputBarSection // extracted computed property
        }
        .padding(.top, CGFloat.spacing16) // 여기에 inputView의 상단 패딩 추가
        .onChange(of: selectedImages) { newItems in
            Task {
                var newPreview: [IdentifiableImageData] = []
                var newImagesDataToSend: [Data] = []
                
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        newPreview.append(IdentifiableImageData(data: data, photosPickerItem: item))
                        newImagesDataToSend.append(data)
                    }
                }
                
                // 모든 로드가 끝난 후 MainActor에서 상태 한 번에 업데이트
                await MainActor.run {
                    previewImages = newPreview
                    imagesDataToSend = newImagesDataToSend
                }
            }
        }
    }
    
    private var imagePreviewSection: some View {
        Group {
            if !previewImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: .spacing8) {
                        ForEach(previewImages) { identifiableImage in
                            ImagePreviewItemView(identifiableImage: identifiableImage) // 단순화된 뷰 사용
                                .padding(.spacing8)
                                .overlay(alignment: .topTrailing) { // Button을 Overlay로 추가
                                    Button {
                                        withAnimation { // 애니메이션 적용
                                            let updatedPreviewImages = previewImages.filter { $0.id != identifiableImage.id }
                                            previewImages = updatedPreviewImages
                                            selectedImages = updatedPreviewImages.map { $0.photosPickerItem }
                                            imagesDataToSend = updatedPreviewImages.map { $0.data }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.black, .white)
                                            .font(.system(size: 16))
                                    }
                                }
                                .transition(.scale) // Transition 적용
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 70)
                .padding(.bottom, .spacing16)
            }
        }
    }
    
    private var inputBarSection: some View {
        HStack(spacing: 12) {
            PhotosPicker(selection: $selectedImages, maxSelectionCount: 5, matching: .images) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            TextField("메시지를 입력해주세요...", text: $messageText)
                .font(.system(size: 14))
                .padding(.horizontal, 12) // 기존의 .padding() 대신 수평 패딩만
                .padding(.vertical, 8) // 기존의 .padding() 대신 수직 패딩만
                .frame(height: 40)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .disabled(messageText.isEmpty && previewImages.isEmpty) // previewImages 사용
        }
        .padding(.horizontal, 16) // 전체 입력 바의 수평 패딩
    }
    
    private func sendMessage() {
        viewModel.input.sendMessage.send((messageText, imagesDataToSend.isEmpty ? nil : imagesDataToSend))
        messageText = ""
        selectedImages = []
        previewImages = [] // 미리보기 초기화
        imagesDataToSend = [] // 전송용 데이터 초기화
    }
}
