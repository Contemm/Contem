//
//  UserProfileRequest.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

enum UserProfileRequest: TargetTypeProtocol {
    // MARK: - Case
    case getMyProfile
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getMyProfile:
            return "/users/me/profile"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .getMyProfile:
            return .get
        }
    }
    
    // MARK: - Headers
    var headers: [String : String] {
        return [
            "Authorization": "로그인 응답 후 Keychain 혹은 UserDefaults에 저장된 accessToken값",
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    // MARK: - Parameters
    
    var parameters: [String : Any] {
        switch self {
        case .getMyProfile:
            [:]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .getMyProfile:
            nil
        }
    }
}
