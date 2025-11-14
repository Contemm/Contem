//
//  KeychainManager.swift
//  Contem
//
//  Created by HyoTaek on 11/14/25.
//

import Foundation

enum TokenType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}

enum KeychainError: Error {
    case encodingFailed
    case decodingFailed
    case itemNotFound
    case unexpectedStatus(OSStatus)
}

protocol KeychainManagerProtocol {
    func save(token: String, for type: TokenType) throws
    func saveAllTokens(accessToken: String, refreshToken: String) throws
    func read(for type: TokenType) throws -> String
    func delete(for type: TokenType) throws
    func deleteAllTokens() throws
    var hasToken: Bool { get }
}

final class KeychainManager: KeychainManagerProtocol {

    static let shared = KeychainManager()

    private init() {}
    
    // MARK: - Save
    
    func save(token: String, for type: TokenType) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.rawValue,
            kSecValueData: data
        ] as CFDictionary

        // 기존 항목 삭제 후 저장
        SecItemDelete(query)

        let status = SecItemAdd(query, nil)

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func saveAllTokens(accessToken: String, refreshToken: String) throws {
        try save(token: accessToken, for: .accessToken)
        try save(token: refreshToken, for: .refreshToken)
    }
    
    // MARK: - Read
    
    func read(for type: TokenType) throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.rawValue,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            }
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.decodingFailed
        }
        
        return token
    }
    
    // MARK: - Delete
    
    func delete(for type: TokenType) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.rawValue
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func deleteAllTokens() throws {
        try delete(for: .accessToken)
        try delete(for: .refreshToken)
    }
    
    // MARK: - 토큰 보유 여부 판별
    
    var hasToken: Bool {
        do {
            _ = try read(for: .accessToken)
            return true
        } catch {
            return false
        }
    }
}
