//
//  ShoppingBannerAPI.swift
//  Contem
//
//  Created by 박도원 on 11/15/25.
//

import Foundation

protocol ShoppingAPIProtocol {
    func getBannerList(body: [String: String]) async throws -> PostListDTO
}


final class ShoppingAPI: ShoppingAPIProtocol {
    
    private let networkLayer: NetworkLayerProtocol
    
    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
        self.networkLayer = networkLayer
    }
    
    func getBannerList(body: [String: String]) async throws -> PostListDTO {
        let router = ShoppingRouter.banner(body: body)
        return try await networkLayer.networkRequest(router: router, model: PostListDTO.self)
    }
    
    
}
