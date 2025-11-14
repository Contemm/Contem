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
    case unexpectedStatus(OSStatus)
}

protocol KeychainManagerProtocol {
    func create(token: String, for type: TokenType) throws
}

final class KeychainManager: KeychainManagerProtocol {

    static let shared = KeychainManager()

    private init() {}
    
    // MARK: - Create
    
    func create(token: String, for type: TokenType) throws {
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
}
