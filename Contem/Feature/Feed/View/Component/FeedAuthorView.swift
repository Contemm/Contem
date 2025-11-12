//
//  FeedAuthorView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI

struct FeedAuthorView: View {
    
    // MARK: - Properties
    
    let author: Author
    let likeCount: Int
    var profileSize: CGFloat = 24

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: .spacing8) {
            AsyncImage(url: URL(string: author.profileImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: profileSize, height: profileSize)
            .clipShape(Circle())

            Text(author.nickname)
                .font(.captionLarge)

            Spacer()

            // 좋아요 수
            HStack(spacing: .spacing4) {
                Image(systemName: "heart")
                    .font(.caption2)
                Text("\(likeCount)")
                    .font(.caption2)
            }
            .foregroundColor(.gray500)
        }
    }
}
