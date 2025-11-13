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
            // 썸네일 이미지
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            // 해시태그 텍스트
            Text(item.hashtag)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .lineLimit(1)
        }
        .frame(width: 60)
    }
}
