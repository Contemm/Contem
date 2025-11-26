//
//  ChatRequest.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation

enum ChatRequest: TargetTypeProtocol{
    case chatRoom(opponentId: String)
    
    var path: String{
        switch self {
        case .chatRoom:
            return "/chats"
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .chatRoom:
                .post
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
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .chatRoom(let opponentId):
            nil
        }
    }
}
