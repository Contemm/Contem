//
//  MessageRowView.swift
//  Contem
//
//  Created by 이상민 on 11/29/25.
//

import SwiftUI
import Kingfisher

struct MessageRowView: View {
    let message: ChatMessageObject
    let isMyMessage: Bool
    var onImageLoaded: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !isMyMessage {
                VStack(alignment: .leading, spacing: .spacing4) {
                    Text(message.sender?.nick ?? "알 수 없음")
                        .font(.captionRegular)
                        .foregroundColor(.gray700)
                    
                    messageContent
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .trailing, spacing: .spacing4) {
                    Text("나")
                        .font(.captionRegular)
                        .foregroundColor(.gray700)
                    messageContent
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
    
    private var messageContent: some View {
        HStack(alignment: .bottom, spacing: .spacing8) {
            if isMyMessage {
                timestamp
            }
            
            VStack(
                alignment: isMyMessage ? .trailing : .leading,
                spacing: .spacing8
            ) {
                if let content = message.content, !content.isEmpty {
                    Text(content)
                        .font(.bodyRegular)
                }
                
            if !message.fileURLs.isEmpty {
                ForEach(message.fileURLs, id: \.self) { url in
                        KFImage(url)
                            .requestModifier(MyImageDownloadRequestModifier())
                            .onSuccess { _ in
                                if url == message.fileURLs.last {
                                    onImageLoaded?()
                                }
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220, maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))                }
            }            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isMyMessage ? Color.blue : .gray50)
            .foregroundColor(isMyMessage ? .primary0 : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            if !isMyMessage {
                timestamp
            }
        }
    }
    
    private var timestamp: some View {
        Text(message.createdAt, style: .time)
            .font(.captionSmall)
            .foregroundColor(.gray700)
    }
}
