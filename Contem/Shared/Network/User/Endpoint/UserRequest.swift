//
//  UserRequest.swift
//  Contem
//
//  Created by 이상민 on 11/18/25.
//

import Foundation

enum UserRequest: TargetTypeProtocol {
    // MARK: - Case
    case login(email: String, password: String)
    
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    // MARK: - Headers
    var headers: [String : String] {
        return [
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    // MARK: - Parameters
    var parameters: [String : Any] {
        switch self {
        case .login(let email, let password):
            ["email": email, "password": password]
        }
    }
    
    var hasAuthorization: Bool{
        switch self {
        case .login(let email, let password):
            return false
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .login:
            nil
        }
    }
}
