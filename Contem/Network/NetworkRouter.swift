//
//  NetworkRouter.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

/// HTTP 메서드 정의
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - Network Router

protocol NetworkRouter {

    /// Base URL
    var baseURL: String { get }
    
    /// API 경로
    var path: String { get }
    
    /// HTTP 메서드
    var method: HTTPMethod { get }
    
    /// 요청 헤더
    var headers: [String: String]? { get }
    
    /// 요청 파라미터
    var parameters: [String: Any]? { get }
}

// TODO: - Multipart/Form-data 추가 예정
