//
//  StyleEntity.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import Foundation

struct StyleEntity{
    let postId: String
    let category: String?
    let title: String?
    let content: String?
    let value1: String?
    let value2: String?
    let value3: String?
    let value4: String?
    let value5: String?
    let createdAt: String
    let creator: StyleCreatorEntity
    let files: [String] //이미지들
    var likes: [String]
    let commentCount: Int
    
    var likeCount: String{
        likes.count.description
    }
    
    var imageUrls: [URL?]{
        files.map{ URL(string: APIConfig.baseURL + $0) }
    }
    
    mutating func toggleLike(userId: String){
        if let index = likes.firstIndex(of: userId){
            likes.remove(at: index)
        }else{
            likes.append(userId)
        }
    }
}

struct StyleCreatorEntity {
    let userId: String
    let nick: String
    let profileImage: String?
    
    var profileImageUrls: URL?{
        guard let profileImage = profileImage else { return nil }
        return URL(string: APIConfig.baseURL + profileImage)
    }
}

struct StyleTag: Identifiable{
    let id = UUID()
    let relX: CGFloat //0~1 비율
    let relY: CGFloat
}
