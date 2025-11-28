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

struct ChattingView: View {
    @ObservedObject private var viewModel: ChattingViewModel
    
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
                    // Header is now inside the scrollable content
                    ChatHeaderView(
                        nickname: viewModel.output.opponentNickname,
                        profileImage: viewModel.output.opponentProfileImage
                    )
                    
                    if let messages = viewModel.output.messages {
                        ForEach(messages) { message in
                            MessageRowView(
                                message: message,
                                isMyMessage: message.sender?.userId == viewModel.output.currentUserId
                            )
                        }
                    } else {
                        ProgressView()
                    }
                    
                    // Add a targetable spacer at the very bottom
                    Spacer().frame(height: 0).id("bottom-spacer")
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom)
                .onChange(of: viewModel.output.messages?.count) { _ in
                    scrollToBottom(proxy: scrollViewProxy, id: "bottom-spacer")
                }
                .onAppear {
                    scrollToBottom(proxy: scrollViewProxy, id: "bottom-spacer")
                }
            }
        }
        .background(.white)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, id: String?) {
        guard let id = id else { return }
        proxy.scrollTo(id, anchor: .bottom)
    }
}

private struct MessageInputView: View {
    @ObservedObject var viewModel: ChattingViewModel
    @State private var messageText: String = ""
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("메시지를 입력해주세요...", text: $messageText)
                .font(.system(size: 14)) // Assuming .bodyRegular
                .padding(.horizontal, 12)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
        .background(.thinMaterial)
    }
    
    private func sendMessage() {
        viewModel.input.sendMessage.send(messageText)
        messageText = ""
    }
}
