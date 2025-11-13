//
//  HashTagCellView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI

struct HashTagCellView: View {
    
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
