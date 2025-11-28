//
//  ChatMessageObject.swift
//  Contem
//
//  Created by 이상민 on 11/28/25.
//

import Foundation
import RealmSwift

final class ChatMessageObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var roomId: String
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var sender: SenderObject?
    @Persisted var files: List<String>
    
    convenience init(chatId: String, roomId: String, content: String?, createdAt: Date, sender: SenderObject, files: [String]) {
        self.init()
        self.chatId = chatId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.sender = sender
        self.files.append(objectsIn: files)
    }
}

final class SenderObject: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var userId: String
    @Persisted var nick: String
    @Persisted var profileImage: String?
    
    convenience init(userId: String, nick: String, profileImage: String?) {
        self.init()
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}

extension ChatResponseDTO {
    func toRealmObject() -> ChatMessageObject {
        let sender = SenderObject(userId: self.sender.userId,
                                  nick: self.sender.nick,
                                  profileImage: self.sender.profileImage)
        
        return ChatMessageObject(chatId: self.chatId,
                                 roomId: self.roomId,
                                 content: self.content,
                                 createdAt: self.createdAt,
                                 sender: sender,
                                 files: self.files)
    }
}

