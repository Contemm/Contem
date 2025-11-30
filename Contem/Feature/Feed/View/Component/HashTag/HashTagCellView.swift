//
//  HashTagCellView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI
import Kingfisher

struct HashTagCellView: View {
    
    // MARK: - Properties
    
    let item: HashtagModel

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: .spacing4) {
            // 썸네일 이미지
            KFImage(item.imageURL)
                .placeholder {
                    Color.gray50
                }
                .requestModifier(MyImageDownloadRequestModifier())
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .background(.gray50)
                .clipShape(Circle())

            // 해시태그 텍스트
            Text(item.hashtag)
                .font(.captionSmall)
                .foregroundColor(.black)
                .lineLimit(1)
        }
        .frame(width: 60)
    }
}
