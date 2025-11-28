//
//  PaymentRequest.swift
//  Contem
//
//  Created by 박도원 on 11/27/25.
//

import Foundation


enum PaymentRequest: TargetTypeProtocol {
    // MARK: - Case
    case paymentValid(uid: String, postId: String)
    case paymentHistory // 결제 내역 보기
    
    // MARK: - Path
    var path: String {
        switch self {
        case .paymentValid:
            return "/payments/validation"
        case .paymentHistory:
            return "/payments/me"
        }
    }
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .paymentValid:
            return .post
        case .paymentHistory:
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
        switch self {
        case .paymentValid(let uid, let postId):
            return [
                "imp_uid":uid,
                "post_id":postId
            ]
        case .paymentHistory:
            return [:]
        }
    }
    
    var multipartFiles: [MultipartFile]?{
        switch self {
        case .paymentValid:
            return nil
        case .paymentHistory:
            return nil
        }
    }
}
