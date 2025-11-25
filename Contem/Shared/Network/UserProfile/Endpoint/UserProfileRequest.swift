//
//  UserProfileRequest.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

enum UserProfileRequest: TargetTypeProtocol {
    // MARK: - Case
    case getMyProfile
    case getOtherProfile(userId: String)
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getMyProfile:
            return "/users/me/profile"
        case .getOtherProfile(let userId):
            return "/users/\(userId)/profile"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .getMyProfile, .getOtherProfile:
            return .get
        }
    }
    
    // MARK: - Headers
    var headers: [String : String] {
        return [
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    // MARK: - Parameters
    var parameters: [String : Any] {
        [:]
    }
    
    var multipartFiles: [MultipartFile]?{
        return nil
    }
}
