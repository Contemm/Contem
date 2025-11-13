//
//  FeedImageView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI

struct FeedImageView: View {
    
    // MARK: - Properties

    let imageName: String
    let aspectRatio: Double

    // MARK: - Body

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(aspectRatio, contentMode: .fill)
    }
}
