//
//  ChatListDTO.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation

struct ChatListDTO: Codable {
    let data: [ChatResponseDTO]
}

struct ChatResponseDTO: Codable {
    let chatId: String
    let roomId: String
    let content: String?
    let createdAt: Date
    let sender: Sender
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case sender
        case files
    }

    struct Sender: Codable {
        let userId: String
        let nick: String
        let profileImage: String?

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case nick
            case profileImage
        }
    }
}

extension ChatResponseDTO{
    func toEntity() -> ChatMessageEntity{
        return ChatMessageEntity(
            chatId: chatId,
            roomId: roomId,
            content: content,
            createdAt: createdAt,
            sender: .init(userId: sender.userId,
                          nick: sender.nick,
                          profileImage: sender.profileImage),
            files: files)
    }
}
