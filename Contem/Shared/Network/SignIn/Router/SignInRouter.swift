//
//  SignInRouter.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

enum SignInRouter: NetworkRouter {
    
    // MARK: - Case

    /// 로그인
    case signIn(body: [String: String])
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .signIn:
            return "/users/login"
        }
    }
    
    // MARK: - Method
    
    var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    // MARK: - Headers
    
    var headers: [String : String]? {
        return [
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    // MARK: - Parameters
    
    var parameters: [String : Any]? {
        switch self {
        case .signIn(let body):
            return body
        }
    }
}
