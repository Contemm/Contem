//
//  ChatRequest.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation

enum ChatRequest: TargetTypeProtocol{
    case chatRoom(opponentId: String) //채팅방 생성(조회)
    case fetchMessage(roomId: String, cursor_date: String) //채팅 내역 조회
    
    var path: String{
        switch self {
        case .chatRoom:
            return "/chats"
        case .fetchMessage(let roomId, _):
            return "/chats/\(roomId)"
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .chatRoom:
                .post
        case .fetchMessage:
                .get
        }
    }
    
    var headers: [String : String]{
        return [
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    var parameters: [String : Any]{
        switch self {
        case .chatRoom(let opponentId):
            return ["opponent_id": opponentId]
        case .fetchMessage(_, let cursor_date):
            return ["cursor_date": cursor_date]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .chatRoom,.fetchMessage:
            return nil
        }
    }
}
