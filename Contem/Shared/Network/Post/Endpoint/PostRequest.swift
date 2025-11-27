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
    
    // MARK: - Path
    var path: String {
        switch self {
        case .postList:
            return "/v1/posts"
        case .postFiles:
            return "/v1/posts/files"
        case .post(let postId):
            return "/v1/posts/\(postId)"
        case .like(let postId, _):
            return "/v1/posts/\(postId)/like"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .postList, .post:
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
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .postList, .post:
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
