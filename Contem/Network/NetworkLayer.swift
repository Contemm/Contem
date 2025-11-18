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

// MARK: - NetworkLayer

final class NetworkLayer: NetworkLayerProtocol {

    // MARK: - Singleton

    static let shared = NetworkLayer()
    
    // MARK: - Properties
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30    // 개별 요청 제한시간: 30초
        configuration.timeoutIntervalForResource = 60   // 다운로드 요청 제한시간: 60초
        
        return URLSession(configuration: configuration)
    }()

    // MARK: - Init

    private init() {}

    // MARK: - Network Request

    /// API 요청 공통 함수
    /// - Parameters:
    ///   - router: NetworkRouter 프로토콜을 채택한 Router
    ///   - model: 디코딩할 응답 모델 타입
    /// - Returns: 디코딩된 모델 객체
    /// - Throws: NetworkError - 네트워크 또는 디코딩 실패 시
    func networkRequest<T: Decodable>(
        router: NetworkRouter,
        model: T.Type
    ) async throws -> T {
        // URLRequest 생성
        let request = try router.asURLRequest()
        
        // 네트워크 요청 수행
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch let error as URLError {
            // URLError 처리
            if error.code == .timedOut {
                throw NetworkError.timeout
            } else {
                throw NetworkError.networkFailure(error)
            }
        } catch {
            // 기타 에러
            throw NetworkError.networkFailure(error)
        }

        // HTTPURLResponse 검증
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // 상태 코드 검증
        switch httpResponse.statusCode {
        case 200..<300:
            // 성공일 경우 디코딩 시도
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(model, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingFailed
            }
            
            // 실패할 경우 상태코드에 따른 분기처리
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownError
        }
    }
}
