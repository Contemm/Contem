//
//  RefreshRequest.swift
//  Contem
//
//  Created by 이상민 on 11/21/25.
//

import Foundation

enum RefreshRequest: TargetTypeProtocol{
    case refresh(refreshToken: String)
    
    var path: String{
        switch self {
        case .refresh:
            return "/auth/refresh"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .refresh:
            return .get
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .refresh(let refreshToken):
            return [
                "RefreshToken": refreshToken,
                "SeSACKey": APIConfig.sesacKey,
                "ProductId": APIConfig.productID
            ]
        }
    }
    
    var parameters: [String : Any]{
        switch self {
        case .refresh:
            return [:]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .refresh:
            return nil
        }
    }
    
    
}
