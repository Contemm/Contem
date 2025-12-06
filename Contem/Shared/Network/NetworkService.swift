//
//  NetworkService.swift
//  Contem
//
//  Created by 이상민 on 11/18/25.
//

import Foundation
import Combine

final class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    private static let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }()
    
    let sessionExpiredSubject = PassthroughSubject<Void, Never>()
    
    @discardableResult
    func callRequest<T: Decodable>(router: TargetTypeProtocol, type: T.Type) async throws -> T {
        do {
            // 1차 시도
            return try await send(router: router, type: type)
        } catch let error as NetworkError {
            if case .statusCodeError(let status) = error{
                switch status {
                case .accessTokenExpired, .unauthorized, .forbidden:
                    if !router.hasAuthorization || router.path
                        .contains("/auth/refresh") {
                        throw error
                    }
                    
                    do {
                        let newToken = try await TokenStorage.shared.refreshAccessToken()
                        return try await send(router: router, type: type, overrideToken: newToken)
                    } catch {
                        sessionExpiredSubject.send(())
                        throw error
                    }
                    
                default:
                    break // 갱신 대상 아님
                }
            }
            //401이 아닌 다른 NetworkError는 그대로 던짐
            throw error
        }catch{
            //알 수 없는 에러
            throw error
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
        
        let (data, response) = try await Self.urlSession.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if (200..<300).contains(http.statusCode){
            if type == EmptyResponseDTO.self {
                
                if let emptyValue = EmptyResponseDTO() as? T {
                    return emptyValue
                }
                
                throw NetworkError.decodingFailed
            }
            do{
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(type, from: data)
            }catch{
                throw NetworkError.decodingFailed
            }
        }
        
        throw NetworkError.mapping(error: nil, response: http, data: data)
    }
}
