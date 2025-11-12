//
//  FeedModel.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

struct FeedModel: Identifiable, Hashable {
    let id = UUID()
    let thumbnailImages: [String]
    let author: Author
    let likeCount: Int
    let title: String
    let hashTags: [String]
    let imageAspectRatio: Double // 이미지의 가로/세로 비율 (width / height)
}

struct Author: Identifiable, Hashable {
    let id = UUID()
    let profileImage: String
    let nickname: String
}
