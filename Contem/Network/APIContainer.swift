//
//  APIContainer.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

// MARK: - APIContainerProtocol

protocol APIContainerProtocol {
//    var profileAPI: ProfileAPIProtocol { get }
}

// MARK: - APIContainer

/// 앱의 모든 API를 관리하는 Container (Protocol + DI + Lazy 패턴)
final class APIContainer: APIContainerProtocol {

    // MARK: - Singleton
    
    static let shared = APIContainer()

    // MARK: - Properties

    /// NetworkLayer (모든 API가 공유)
    private let networkLayer: NetworkLayerProtocol
    
    // MARK: - APIs
    
    /// Profile API
//    lazy var profileAPI: ProfileAPIProtocol = {
//        return ProfileAPI(networkLayer: networkLayer)
//    }()

    // MARK: - Init
    
    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
        self.networkLayer = networkLayer
    }
}
