//
//  StyleDetailRouter.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

enum StyleDetailRouter: NetworkRouter{
    //MARK: - Case
    case fetchStyleDetail(postId: String)
    
    //MARK: - Path
    var path: String{
        switch self{
        case .fetchStyleDetail(let postId):
            return "posts/\(postId)"
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .fetchStyleDetail:
            return .get
        }
    }
    
    var headers: [String: String]?{
        let authorization = try! KeychainManager.shared.read(for: .accessToken)
        return [
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5MTQzOTk3ZmY5NDkyNzk0OGZlYTk2MCIsImlhdCI6MTc2MjkzMzE5OSwiZXhwIjoxNzYzMDA1MTk5LCJpc3MiOiJzZXNhY18zIn0.hZmAwDZmCgeKLq8JAE9LChdtrtjbWofHVV3S0dagzp4",
            "SeSACKey": APIConfig.sesacKey,
            "ProductId": APIConfig.productID
        ]
    }
    
    var parameters: [String : Any]?{
        switch self{
        case .fetchStyleDetail:
            nil
        }
    }
}
