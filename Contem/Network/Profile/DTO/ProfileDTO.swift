//
//  ProfileDTO.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

/// 본인 / 타인 프로필 조회 및 본인 프로필 수정 응답 DTO
struct ProfileDTO: Codable {
    let userID: String
    let email: String
    let nickname: String
    let phoneNumber: String
    let gender: String
    let birthDay: String
    let info1: String
    let info2: String
    let info3: String
    let info4: String
    let info5: String
    let followers: [String]
    let following: [String]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname = "nick"
        case phoneNumber = "phoneNum"
        case gender
        case birthDay
        case info1
        case info2
        case info3
        case info4
        case info5
        case followers
        case following
        case posts
    }
}
