//
//  NetworkRouter.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

/// HTTP 메서드 정의
//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case delete = "DELETE"
//    case patch = "PATCH"
//}

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

extension NetworkRouter {

    var baseURL: String {
        return APIConfig.baseURL
    }

    /// 전체 URL을 반환 (baseURL + path)
    var urlString: String {
        return baseURL + path
    }

    /// URLRequest를 생성하여 반환
    func asURLRequest() throws -> URLRequest {
        // URL 생성
        guard var urlComponents = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }

        // HTTP 메서드별 parameter 처리
        switch method {
        case .get:
            // GET: parameters를 URLQueryItem으로 변환
            if let parameters = parameters {
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
            }

        case .post, .put, .delete:
            // POST/PUT/PATCH/DELETE: parameters는 httpBody로 설정 (아래에서 처리)
            break
        }
        
        // URL 검증
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30

        // Headers 설정
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // HTTP 메서드별 Request Body 처리
        switch method {
        case .post, .put, .delete:
            // POST/PUT/PATCH/DELETE: parameters를 JSON으로 인코딩하여 httpBody 설정
            if let parameters = parameters {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }
            
        case .get:
            // GET: query string으로 이미 처리됨
            break
        }

        return request
    }
}

// TODO: - Multipart/Form-data 추가 예정
