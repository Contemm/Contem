//
//  FeedImageView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI
import Kingfisher

struct FeedImageView: View {
    
    // MARK: - Properties

    let imageURL: URL

    // MARK: - Body

    var body: some View {
        KFImage(imageURL)
            .placeholder {
                Color.gray50
            }
            .requestModifier(MyImageDownloadRequestModifier())
            .resizable()
            .scaledToFill()
    }
}
