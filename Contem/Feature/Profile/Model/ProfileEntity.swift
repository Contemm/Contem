//
//  ProfileEntity.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import Foundation

struct ProfileEntity{
    let userId: String
    let nick: String
    let profileImage: String?
    let info1: String
    let info2: String
    let info3: String
    let info4: String
    let info5: String
    let followers: [ProfileCreatorEntity]
    let following: [ProfileCreatorEntity]
    let posts: [String]
    
    var followerCount: String{
        followers.count.description
    }
    
    var followingCount: String{
        following.count.description
    }
    
    var imageUrls: URL?{
        guard let profileImage else { return nil }
        return URL(string: APIConfig.baseURL + profileImage)
    }
    
    func isFollowing(userId: String?) -> Bool{
        guard let userId else { return false }
        return followers.contains { user in
            userId == userId
        }
    }
}

struct ProfileCreatorEntity{
    let userId: String
    let nick: String
    let profileImage: String?
    
    var profileImageUrls: URL?{
        guard let profileImage = profileImage else { return nil }
        return URL(string: APIConfig.baseURL + profileImage)
    }
}
