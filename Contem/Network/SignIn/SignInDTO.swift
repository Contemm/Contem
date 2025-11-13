//
//  SignInDTO.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

/// 로그인 응답 DTO
struct SignInDTO: Codable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname = "nick"
        case profileImage
        case accessToken
        case refreshToken
    }
}
