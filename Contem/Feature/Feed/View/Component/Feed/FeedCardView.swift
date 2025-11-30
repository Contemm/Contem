//
//  FeedCardView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI

struct FeedCardView: View {
    // MARK: - Properties
    
    let feed: FeedModel
    let cardWidth: CGFloat
    let isLiked: Bool
    let onLikeTapped: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            // 썸네일 이미지(동적 높이)
            if let firstImage = feed.thumbnailImages.first {
                FeedImageView(imageURL: firstImage)
                    .frame(width: cardWidth)
                    .clipped()
                    .cornerRadius(.radiusSmall)
                    .overlay(
                        // 썸네일 이미지가 2개 이상일 때 스택 아이콘 표시
                        Group {
                            if feed.thumbnailImages.count > 1 {
                                Image(asset: .filledStack)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.spacing8)
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity,
                                        alignment: .topTrailing
                                    )
                            }
                        }
                    )
            }

            // 하단 정보 영역
            VStack(alignment: .leading, spacing: .spacing4) {
                HStack{
                    // 작성자 정보
                    FeedAuthorView(writer: feed.writer, writerImage: feed.writerImage)
                    HStack(spacing: .spacing4){
                        Button {
                            onLikeTapped()
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .scaledToFit()
                                .foregroundStyle(isLiked ? .red : .gray300)
                        }
                        
                        Text("\(feed.likeCount)")
                            .monospaced()
                            .font(.bodyRegular)
                            .foregroundStyle(.gray300)
                    }
                }//: HSTACK
                // 내용
                FeedContentView(
//                    title: feed.title,
                    content: feed.content
                )
            }
            .padding(.spacing8)
            
        }
        .frame(width: cardWidth)
        .background(Color.white)
    }
}
