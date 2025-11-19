//
//  PostDTO.swift
//  Contem
//
//  Created by 박도원 on 11/15/25.
//

import Foundation


struct PostDTO: Codable {
    let postID: String
    let category: String?
    let title: String?
    let price: Int?
    let content: String?
    let value1: String?
    let value2: String?
    let value3: String?
    let value4: String?
    let value5: String?
    let value6: String?
    let value7: String?
    let value8: String?
    let value9: String?
    let value10: String?
    let createdAt: String
    let creator: UserDTO
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let buyers: [String]
    let hashTags: [String]
    let commentCount: Int
    let geolocation: Geolocation
    let distance: Double?
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case category, title, price, content
        case value1, value2, value3, value4, value5
        case value6, value7, value8, value9, value10
        case createdAt, creator, files
        case likes, likes2, buyers, hashTags
        case commentCount = "comment_count"
        case geolocation, distance
    }
}

struct Geolocation: Codable {
    let longitude: Double
    let latitude: Double
}
