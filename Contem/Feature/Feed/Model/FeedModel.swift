//
//  FeedModel.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

struct FeedModel: Identifiable, Hashable {
    let id = UUID()
    let postId: String
    let thumbnailImages: [URL]
    let writer: String
    let writerImage: String?
    let title: String
    let content: String
    let hashTags: [String]
    let commentCount: Int
}

struct HashtagModel: Identifiable, Hashable {
    let id = UUID()
    let imageURL: URL?
    let hashtag: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imageURL)
        hasher.combine(hashtag)
    }
}

// MARK: - Dummy Data
extension FeedModel {
    static let dummyData: [FeedModel] = [
        FeedModel(
            postId: "1",
            thumbnailImages: [
                URL(string: "https://i.pravatar.cc/150?img=1")!,
                URL(string: "https://i.pravatar.cc/150?img=2")!,
                URL(string: "https://i.pravatar.cc/150?img=3")!
            ],
            writer: "패션러버",
            writerImage: "https://i.pravatar.cc/150?img=1",
            title: "피드 제목1",
            content: "오늘의 데일리룩",
            hashTags: ["#데일리룩", "#오늘의패션", "#OOTD"],
            commentCount: 10
        ),
        FeedModel(
            postId: "2",
            thumbnailImages: [
                URL(string: "https://i.pravatar.cc/150?img=4")!
            ],
            writer: "패션헌터",
            writerImage: "https://i.pravatar.cc/150?img=2",
            title: "피드 제목2",
            content: "스트릿 패션",
            hashTags: ["#스트릿패션", "#패션코디", "#패션스타일"],
            commentCount: 5
        )
    ]
}

