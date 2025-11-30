//
//  FeedContentView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI

struct FeedContentView: View {
    
    // MARK: - Properties
    
    let title: String
    let content: String

    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing4) {
            Text(title)
                .font(.captionLarge)
            Text(content)
                .font(.captionRegular)
        }
    }
}
