import Foundation


struct ChatRoomListEntity {
    let roomList: [ChatRoomEntity]
    
    init(from dto: ChatRoomResponseListDTO) {
        self.roomList = dto.data.map { ChatRoomEntity(from: $0) }
    }
}

struct ChatRoomEntity: Identifiable {
    let id: String
    let partnerInfo: [ParticipantDTO]
    let lastChat: LastChatDTO?
    
    init(from dto: ChatRoomDTO) {
        self.id = dto.roomId
        self.partnerInfo = dto.participants
        self.lastChat = dto.lastChat
        
    }
}
