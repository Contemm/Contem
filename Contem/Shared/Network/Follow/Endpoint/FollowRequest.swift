//
//  FollowRequest.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import Foundation

enum FollowRequest: TargetTypeProtocol{
    case follow(userId: String, isFollow: Bool) //팔로우
    
    var path: String{
        switch self {
        case .follow(let userId, _):
            return "/follow/\(userId)"
        }
    }
    
    var method: HTTPMethod{
        return .post
    }
    
    var headers: [String : String]{
        return [
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    var parameters: [String : Any]{
        switch self {
        case .follow(let userId, let isFollow):
            ["user_id": userId,
             "follow_status": isFollow]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        return nil
    }
}
