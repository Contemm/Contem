//
//  LoginDTO.swift
//  Contem
//
//  Created by 이상민 on 11/18/25.
//

struct LoginDTO: Codable{
    let userID: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nick
        case accessToken
        case refreshToken
    }
}
