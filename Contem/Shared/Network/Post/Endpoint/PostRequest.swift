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
    case post(postId: String) //게시글 한 개 조회
    case like(postId: String, isLiked: Bool) //게시글 좋아요
    case userPostList(userId: String, next: String? = nil, limit: String? = nil, category: String = "style_feed")
    
    // MARK: - Path
    var path: String {
        switch self {
        case .postList:
            return "/posts"
        case .postFiles:
            return "/posts/files"
        case .post(let postId):
            return "/posts/\(postId)"
        case .like(let postId, _):
            return "/posts/\(postId)/like"
        case .userPostList(let userId, _, _ ,_):
            return "/posts/users/\(userId)"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .postList, .post, .userPostList:
            return .get
        case .postFiles, .like:
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
        case .post(let postId):
            return ["post_id": postId]
        case .like(_, let isLiked):
            return [
                "like_status" : isLiked
            ]
        case .userPostList(let userId, let next, let limit, let category):
            var params: [String: String] = ["category":category]
            
            if let next = next {
                params["next"] = next
            }
            
            if let limit = limit {
                params["limit"] = limit
            }
            
            return params
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .postList, .post, .userPostList:
            return nil
        case .postFiles(let files):
            return files.enumerated().map { index, data in
                MultipartFile(
                    name: "files",
                    filename: "image_\(index).jpg",
                    mimeType: "image/jpeg",
                    data: data)
            }
        case .like:
            return nil
        }
    }
}
