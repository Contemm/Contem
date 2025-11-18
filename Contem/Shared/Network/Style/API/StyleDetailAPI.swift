//
//  StyleDetailAPI.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import Foundation

// MARK: - StyleDetailAPIProtocol
protocol StyleDetailAPIProtocol {
    func fetchStyleDetail(postId: String) async throws -> StyleDetailDTO
}

// MARK: - StyleDetailAPI
final class StyleDetailAPI: StyleDetailAPIProtocol {

    // MARK: - Property
    private let networkLayer: NetworkLayerProtocol

    // MARK: - Initializer
    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
        self.networkLayer = networkLayer
    }

    // MARK: - Method
    func fetchStyleDetail(postId: String) async throws -> StyleDetailDTO {
        let router = StyleDetailRouter.fetchStyleDetail(postId: postId)
        return try await networkLayer.networkRequest(router: router, model: StyleDetailDTO.self)
    }
}
