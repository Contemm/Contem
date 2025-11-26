//
//  ChatRoomDTO.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation

struct ChatRoomDTO: Codable{
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [ParticipantDTO]
    let lastChat: LastChatDTO?
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
}

struct ParticipantDTO: Codable{
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct LastChatDTO: Codable{
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: String
    let sender: ParticipantDTO
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case sender
        case files
    }
}
