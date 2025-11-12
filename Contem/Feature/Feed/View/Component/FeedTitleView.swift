//
//  FeedTitleView.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import SwiftUI

struct FeedTitleView: View {
    
    // MARK: - Properties
    
    // 제목과 해시태그를 이어서 표시
    private var titleWithHashTags: String {
        if hashTags.isEmpty {
            return title
        }
        return title + " " + hashTags.joined(separator: " ")
    }
    private let title: String
    private let hashTags: [String]

    // MARK: - Body
    
    var body: some View {
        Text(titleWithHashTags)
            .font(.captionRegular)
    }
}
