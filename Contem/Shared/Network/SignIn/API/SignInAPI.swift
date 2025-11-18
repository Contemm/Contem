//
//  SignInAPI.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

// MARK: - ProfileAPIProtocol

/// SignInAPI의 추상화 프로토콜
protocol SignInAPIProtocol {
    /// 로그인 요청
    func signIn(body: [String: String]) async throws -> SignInDTO
}

// MARK: - SignInAPI

///
/// **Protocol + DI 패턴:**
/// ```swift
///   SignIn API
///   lazy var signInAPI: SignInAPIProtocol = {
///       return SignInAPI(networkLayer: networkLayer)
///   }()
final class SignInAPI: SignInAPIProtocol {

    // MARK: - Property

    /// 네트워크 레이어 (DI로 주입받음)
    private let networkLayer: NetworkLayerProtocol

    // MARK: - Initializer

    /// NetworkLayer를 주입받는 생성자
    init(networkLayer: NetworkLayerProtocol = NetworkLayer.shared) {
        self.networkLayer = networkLayer
    }

    // MARK: - Method

    /// 로그인 요청
    func signIn(body: [String: String]) async throws -> SignInDTO {
        let router = SignInRouter.signIn(body: body)
        return try await networkLayer.networkRequest(router: router, model: SignInDTO.self)
    }
}
