//
//  NetworkService.swift
//  Contem
//
//  Created by 이상민 on 11/18/25.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    private let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        return URLSession(configuration: config)
    }()
    
    func callRequest<T: Decodable>(router: TargetTypeProtocol, type: T.Type) async throws -> T {
        do {
            // 1차 시도
            return try await send(router: router, type: type)
        } catch NetworkError.unauthorized {
            if router.path
                .contains("/auth/refresh") || !router.hasAuthorization {
                throw NetworkError.unauthorized
            }
            
            // TokenStorage에게 갱신 요청 (실패 시 refreshTokenExpired 에러 던짐)
            let newToken = try await TokenStorage.shared.refreshAccessToken()
            
            // 갱신 성공 -> 재요청
            return try await send(router: router, type: type, overrideToken: newToken)
        }
    }
    
    // MARK: - Private Send Method
    private func send<T: Decodable>(
        router: TargetTypeProtocol,
        type: T.Type,
        overrideToken: String? = nil
    ) async throws -> T {
        
        var request = try router.asUrlRequest()
        
        // 재요청 시 새 토큰 주입
        if let overrideToken {
            request.setValue(overrideToken, forHTTPHeaderField: "Authorization")
        } else {
            // 일반 요청 시
                if router.hasAuthorization,
                   let token = await TokenStorage.shared.getAccessToken(), !token.isEmpty {
                    request.setValue(token, forHTTPHeaderField: "Authorization")
                }
        }
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch http.statusCode {
        case 200..<300:
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
            
        case 400: throw NetworkError.badRequest
        case 401: throw NetworkError.unauthorized
        case 403: throw NetworkError.forbidden
        case 404: throw NetworkError.notFound
        case 418: throw NetworkError.refreshTokenExpired
        case 500..<600: throw NetworkError.serverError
        default: throw NetworkError.unknownError
        }
    }
}
