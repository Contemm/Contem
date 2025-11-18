//
//  StyleDetailDTO.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import Foundation

struct StyleDetailDTO: Codable {
    let postId: String
    let category: String
    let title: String
    let price: Int
    let content: String
    let value1: String
    let value2: String
    let value3: String
    let value4: String
    let value5: String
    let value6: String
    let value7: String
    let value8: String
    let value9: String
    let value10: String
    let createdAt: String
    let creator: StyleCreator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let buyers: [String]
    let hashTags: [String]
    let commentCount: Int
    let geolocation: StyleDetailLocation
    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case category
        case title
        case price
        case content
        case value1
        case value2
        case value3
        case value4
        case value5
        case value6
        case value7
        case value8
        case value9
        case value10
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case buyers
        case hashTags
        case commentCount = "comment_count"
        case geolocation
        case distance
    }
}

struct StyleCreator: Codable{
    let userId: String
    let nick: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct StyleDetailLocation: Codable{
    let longitude: Double
    let latitude: Double
}
