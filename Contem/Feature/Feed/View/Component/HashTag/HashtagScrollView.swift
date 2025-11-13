//
//  HashtagScrollView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI

struct HashtagScrollView: View {
    
    // MARK: - Properties
    
    let items: [HashtagModel]

    // MARK: - Body
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items) { item in
                    HashtagCell(item: item)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct HashtagCell: View {
    
    // MARK: - Properties
    
    let item: HashtagModel

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            // 원형 이미지
            AsyncImage(url: URL(string: item.imageName)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())

            // 해시태그 텍스트
            Text(item.hashtag)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

// MARK: - Preview with Dummy Data

// 더미 데이터 생성 함수
private func createDummyHashtagItems() -> [HashtagItem] {
    // FeedModel.dummyData에서 첫 5개의 해시태그와 이미지를 사용
    let feeds = FeedModel.dummyData.prefix(5)

    return feeds.enumerated().map { index, feed in
        HashtagItem(
            imageName: feed.author.profileImage,
            hashtag: feed.hashTags.first ?? "#패션"
        )
    }
}
