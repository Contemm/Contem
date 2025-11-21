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
    
    func getAccessToken() async -> String? {
        return try? await KeychainManager.shared.read(.accessToken)
    }
    
    func getRefreshToken() async -> String? {
        return try? await KeychainManager.shared.read(.refreshToken)
    }
    
    func getUserId() async -> String?{
        return try? await KeychainManager.shared.read(.userId)
    }
    
    func storeTokens(access: String, refresh: String, userId: String? = nil) async {
        try? await KeychainManager.shared.save(access, for: .accessToken)
        try? await KeychainManager.shared.save(refresh, for: .refreshToken)
        
        if let userId{
            try? await KeychainManager.shared.save(userId, for: .userId)
        }
    }
    
    func clear() async{
        await KeychainManager.shared.clearAll()
    }
    
    func hasValidAccessToken() async -> Bool{
        guard let accessToken = try? await KeychainManager.shared.read(.accessToken) else { return false }
        return !accessToken.isEmpty
    }
}
