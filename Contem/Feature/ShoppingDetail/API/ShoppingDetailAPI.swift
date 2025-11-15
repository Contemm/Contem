//
//  ShoppingDetailAPI.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

// MARK: - ShoppingDetailAPIProtocol

/// ShoppingDetailAPI의 추상화 프로토콜
protocol ShoppingDetailAPIProtocol {
    /// 상품 상세 정보 조회
    func fetchDetail(postId: String) async throws -> ShoppingDetailInfo
}

// MARK: - ShoppingDetailAPI

/// 상품 상세 정보를 가져오는 API
final class ShoppingDetailAPI: ShoppingDetailAPIProtocol {

    // MARK: - Property

    /// 네트워크 레이어 (DI로 주입받음)
    private let networkLayer: NetworkLayerProtocol

    // MARK: - Initializer

    /// NetworkLayer를 주입받는 생성자
    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
        self.networkLayer = networkLayer
    }

    // MARK: - Method

    /// 상품 상세 정보 조회
    func fetchDetail(postId: String) async throws -> ShoppingDetailInfo {
        let router = ShoppingDetailRouter.getDetail(postId: postId)
        return try await networkLayer.networkRequest(router: router, model: ShoppingDetailInfo.self)
    }
}
