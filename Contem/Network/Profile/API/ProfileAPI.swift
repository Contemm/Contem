//
//  ProfileAPI.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

// MARK: - ProfileAPIProtocol

/// ProfileAPI의 추상화 프로토콜
protocol ProfileAPIProtocol {
    /// 본인 프로필 조회
    func getMyProfile() async throws -> ProfileDTO
}

// MARK: - ProfileAPI

///
/// **Protocol + DI 패턴:**
/// ```swift
///   Profile API
///   lazy var profileAPI: ProfileAPIProtocol = {
///       return ProfileAPI(networkLayer: networkLayer)
///   }()
final class ProfileAPI: ProfileAPIProtocol {

    // MARK: - Property

    /// 네트워크 레이어 (DI로 주입받음)
    private let networkLayer: NetworkLayerProtocol

    // MARK: - Initializer

    /// NetworkLayer를 주입받는 생성자
    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
        self.networkLayer = networkLayer
    }

    // MARK: - Method

    /// 본인 프로필 정보 조회
    /// - Returns: ProfileDTO - 프로필 정보
    /// - Throws: NetworkError - 네트워크 또는 디코딩 실패 시
    func getMyProfile() async throws -> ProfileDTO {
        let router = ProfileRouter.getMyProfile
        return try await networkLayer.networkRequest(router: router, model: ProfileDTO.self)
    }
}
