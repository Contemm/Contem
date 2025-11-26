//
//  FollowDTO.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import Foundation

struct FollowDTO: Codable{
    let nick: String
    let opponentNick: String
    let followingStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponentNick = "opponent_nick"
        case followingStatus = "following_status"
    }
}
