//
//  NetworkLayer.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

// MARK: - NetworkLayerProtocol

/// 네트워크 레이어의 추상화 프로토콜
protocol NetworkLayerProtocol {
    
    /// API 요청 공통 함수
    /// - Parameters:
    ///   - router: NetworkRouter 프로토콜을 채택한 Router
    ///   - model: 디코딩할 응답 모델 타입
    func networkRequest<T: Decodable>(
        router: NetworkRouter,
        model: T.Type
    ) async throws -> T
}
