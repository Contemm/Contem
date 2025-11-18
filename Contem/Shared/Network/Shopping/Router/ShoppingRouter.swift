//
//  ShoppingRouter.swift
//  Contem
//
//  Created by 박도원 on 11/15/25.

import Foundation

enum ShoppingRouter: NetworkRouter {

    case banner(body: [String: String])
        
    var path: String {
        switch self {
        case .banner:
            return "/posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .banner:
                .get
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = try? KeychainManager.shared.read(for: .accessToken) else {
            return nil
        }
        
        return [
            "Authorization": accessToken,
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .banner(let body):
            return body
        }
    }
}
