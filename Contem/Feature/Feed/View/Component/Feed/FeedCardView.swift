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
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            // 썸네일 이미지(동적 높이)
            if let firstImage = feed.thumbnailImages.first {
                FeedImageView(imageName: firstImage, aspectRatio: feed.imageAspectRatio)
                    .frame(width: cardWidth)
                    .clipped()
                    .cornerRadius(.radiusSmall)
                    .overlay(
                        // 썸네일 이미지가 2개 이상일 때 스택 아이콘 표시
                        Group {
                            if feed.thumbnailImages.count > 1 {
                                Image(systemName: "rectangle.stack.fill")
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
            VStack(alignment: .leading, spacing: .spacing8) {
                // 작성자 정보 및 좋아요
                FeedAuthorView(author: feed.author, likeCount: feed.likeCount)

                // 제목
                FeedTitleView(
                    title: feed.title,
                    hashTags: feed.hashTags
                )
            }
            .padding(.spacing8)
            
        }
        .frame(width: cardWidth)
        .background(Color.white)
    }
}
