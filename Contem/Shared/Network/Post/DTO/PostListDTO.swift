//
//  PostListDTO.swift
//  Contem
//
//  Created by 박도원 on 11/15/25.
//


struct PostListDTO: Codable {
    let data: [PostDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

