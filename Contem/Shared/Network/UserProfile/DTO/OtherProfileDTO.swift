//
//  OtherProfileDTO.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import Foundation

struct OtherProfileDTO: Codable{
    let userId: String
    let email: String?
    let nick: String
    let profileImage: String?
    let phoneNum: String?
    let gender: String?
    let birthDay: String?
    let info1: String
    let info2: String
    let info3: String
    let info4: String
    let info5: String
    let followers: [UserDTO]
    let following: [UserDTO]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case phoneNum
        case gender
        case birthDay
        case info1
        case info2
        case info3
        case info4
        case info5
        case followers
        case following
        case posts
    }
    
    var profileImageURL: URL?{
        guard let profileImage else { return nil }
        return URL(string: APIConfig.baseURL + profileImage)
    }
}

extension OtherProfileDTO{
    func toEntity() -> ProfileEntity{
        return ProfileEntity(
            userId: userId,
            nick: nick,
            profileImage: profileImage,
            info1: info1,
            info2: info2,
            info3: info3,
            info4: info4,
            info5: info5,
            followers: followers.map{ProfileCreatorEntity(userId: $0.userID, nick: $0.nickname, profileImage: $0.profileImage)},
            following: following.map{ProfileCreatorEntity(userId: $0.userID, nick: $0.nickname, profileImage: $0.profileImage)},
            posts: posts)
    }
}

