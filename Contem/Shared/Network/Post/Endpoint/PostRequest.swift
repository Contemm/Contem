//
//  PostRequest.swift
//  Contem
//
//  Created by 이상민 on 11/19/25.
//

import Foundation

enum PostRequest: TargetTypeProtocol {
    // MARK: - Case
    case postList(next: String? = nil, limit: String? = nil, category: String) //게시글 조회
    case postFiles(files: [Data]) //파일 업로드
    case postItem(postId: String)
    case liked(isLiked: Bool, userId: String)
    
    // MARK: - Path
    var path: String {
        switch self {
        case .postList:
            return "/posts"
        case .postFiles:
            return "/posts/files"
        case .postItem(let postId):
            return "/posts/\(postId)"
        case .liked(_ , let userId):
            return "/posts/\(userId)/like"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .postList:
            return .get
        case .postFiles:
            return .post
        case .postItem:
            return .get
        case .liked:
            return .post
        }
    }
    
    // MARK: - Headers
    var headers: [String : String] {
        return [
            "Authorization": APIConfig.testToken,
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    // MARK: - Parameters
    var parameters: [String : Any] {
        switch self {
        case .postList(let next, let limit, let category):
            var params: [String: Any] = ["category": category]
            
            // next가 nil이 아닐 때만 추가
            if let next = next {
                params["next"] = next
            }
            
            // limit이 nil이 아닐 때만 추가
            if let limit = limit {
                params["limit"] = limit
            }
            return params
        case .postFiles:
            return [:]
        case .postItem:
            return [:]
        case .liked(let isLiked, _):
            return [
                "like_status" : isLiked
            ]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .postList:
            return nil
        case .postItem:
            return nil
        case .postFiles(let files):
            return files.enumerated().map { index, data in
                MultipartFile(
                    name: "files",
                    filename: "image_\(index).jpg",
                    mimeType: "image/jpeg",
                    data: data)
            }
        case .liked:
            return nil
        }
    }
}
