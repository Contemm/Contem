//
//  FeedAuthorView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI
import Kingfisher

struct FeedAuthorView: View {
    
    // MARK: - Properties
    
    let writer: String
    let writerImage: String?
    var profileSize: CGFloat = 24

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: .spacing8) {
            KFImage(URL(string: writerImage ?? ""))
                .placeholder {
                    Color.gray50
                }
                .requestModifier(MyImageDownloadRequestModifier())
                .resizable()
                .scaledToFill()
                .frame(width: profileSize, height: profileSize)
                .clipShape(Circle())

            Text(writer)
                .font(.captionRegular)
                .foregroundStyle(.gray900)

            Spacer()
        }
    }
}
