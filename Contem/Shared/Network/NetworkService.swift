//
//  NetworkService.swift
//  Contem
//
//  Created by 이상민 on 11/18/25.
//

import Foundation
import Combine

final class NetworkService{
    static let shared = NetworkService()
    
    private init(){ }
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 //개별 요청 제한시간: 30초
        configuration.timeoutIntervalForResource = 60 //다운로드 요청 제한시간: 60초
        
        return URLSession(configuration: configuration)
    }()
    
    func callRequest<T: Decodable>(router: TargetTypeProtocol, type: T.Type) async throws -> T{
        let request = try router.asUrlRequest()
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let http = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        
        switch http.statusCode{
        case 200..<300:
            do{
                let decoded = try JSONDecoder().decode(type, from: data)
                return decoded
            }catch{
                throw NetworkError.decodingFailed
            }
            
        case 400: throw NetworkError.badRequest
        case 401: throw NetworkError.unauthorized
        case 403: throw NetworkError.forbidden
        case 404: throw NetworkError.notFound
        case 500..<600: throw NetworkError.serverError
        default: throw NetworkError.unknownError
        }
    }
}
