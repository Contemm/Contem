//
//  ChatMessageEntity.swift
//  Contem
//
//  Created by 이상민 on 11/28/25.
//

import Foundation

struct ChatMessageEntity: Identifiable, Hashable, Sendable {
    let chatId: String
    let roomId: String
    let content: String?
    let createdAt: Date
    let sender: Sender
    let files: [String]

    struct Sender: Codable, Hashable {
        let userId: String
        let nick: String
        let profileImage: String?
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(chatId)
    }

    static func == (lhs: ChatMessageEntity, rhs: ChatMessageEntity) -> Bool {
        lhs.chatId == rhs.chatId
    }
}

extension ChatMessageEntity{
    var id: String { chatId }
}
