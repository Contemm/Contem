//
//  TokenStorage.swift
//  Contem
//
//  Created by 이상민 on 11/20/25.
//

import Foundation

final actor TokenStorage {
    static let shared = TokenStorage()
    private init() {}
    
    //refresh 증복 방지용 Task
    private var refreshTask: Task<String, Error>? = nil
    
    func getAccessToken() async -> String? {
        return try? await KeychainManager.shared.read(.accessToken)
    }
    
    func getRefreshToken() async -> String? {
        return try? await KeychainManager.shared.read(.refreshToken)
    }
    
    func getUserId() async -> String?{
        return try? await KeychainManager.shared.read(.userId)
    }
    
    func storeTokens(access: String, refresh: String, userId: String? = nil) async throws {
        try await KeychainManager.shared.save(access, for: .accessToken)
        try await KeychainManager.shared.save(refresh, for: .refreshToken)
        
        if let userId{
            try await KeychainManager.shared.save(userId, for: .userId)
        }
    }
    
    func clear() async{
        await KeychainManager.shared.clearAll()
    }
    
    func hasValidAccessToken() async -> Bool{
        guard let accessToken = try? await KeychainManager.shared.read(.accessToken) else { return false }
        print("엑세스 토큰: \(accessToken)")
        return !accessToken.isEmpty
    }
    
    func refreshAccessToken() async throws -> String {
        if let task = refreshTask {
            return try await task.value
        }
        
        let task = Task<String, Error> {
            defer { refreshTask = nil }
            
            guard let refreshToken = try? await KeychainManager.shared.read(.refreshToken),
                  !refreshToken.isEmpty else {
                throw NetworkError.statusCodeError(type: .refreshTokenExpired())
            }
            
            let router = RefreshRequest.refresh(refreshToken: refreshToken)
            
            let request = try await router.asUrlRequest()
            
            let data: Data
            let response: URLResponse
            
            do{
                (data, response) = try await URLSession.shared
                    .data(for: request)
            }catch{
                throw NetworkError
                    .mapping(error: error, response: nil, data: nil)
            }
            
            guard let http = response as? HTTPURLResponse else{
                throw NetworkError.invalidResponse
            }
            
            if (200..<300).contains(http.statusCode){
                do{
                    let response = try JSONDecoder().decode(
                        RefreshDTO.self,
                        from: data
                    )
                    
                    try await storeTokens(
                        access: response.accessToken,
                        refresh: response.refreshToken
                    )
                    
                    return response.accessToken
                }catch{
                    throw NetworkError.decodingFailed
                }
            }else{
                let mappedError = NetworkError.mapping(
                    error: nil,
                    response: http,
                    data: data
                )
                
                if http.statusCode == 401 || http.statusCode == 418 || http.statusCode == 403 {
                    await clear()
                }
                
                throw mappedError
            }
        }
        
        self.refreshTask = task
        return try await task.value
    }
}
