//
//  ShoppingDetailRouter.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//
//
//enum ShoppingDetailRouter: NetworkRouter {
//
//    // MARK: - Case
//
//    /// 상품 상세 정보 조회
//    case getDetail(postId: String)
//
//    // MARK: - Path
//
//    var path: String {
//        switch self {
//        case .getDetail(let postId):
//            return "post/\(postId)"
//        }
//    }
//
//    // MARK: - Method
//
//    var method: HTTPMethod {
//        switch self {
//        case .getDetail:
//            return .get
//        }
//    }
//
//    // MARK: - Headers
//
//    var headers: [String: String]? {
//        return [
//            "SeSACKey": APIConfig.sesacKey,
//            "ProductId": APIConfig.productID
//        ]
//    }
//
//    // MARK: - Parameters
//
//    var parameters: [String: Any]? {
//        switch self {
//        case .getDetail:
//            return nil
//        }
//    }
//}
