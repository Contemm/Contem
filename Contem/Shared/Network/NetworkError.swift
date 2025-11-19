//
//  NetworkError.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

enum NetworkError: Error {

    /// 잘못된 URL 형식
    case invalidURL

    /// 응답이 HTTPURLResponse가 아닌 경우
    case invalidResponse
    
    /// 400 - 잘못된 요청
    case badRequest

    /// 401 - 인증 실패 (토큰 만료, 잘못된 인증 정보)
    case unauthorized

    /// 403 - 접근 권한 없음
    case forbidden

    /// 404 - 요청한 리소스를 찾을 수 없음
    case notFound

    /// 500 - 서버 내부 오류
    case serverError

    /// 응답 데이터 디코딩 실패
    case decodingFailed

    /// 네트워크 연결 실패 (underlying error 포함)
    case networkFailure(Error)

    /// 요청 타임아웃
    case timeout
    
    /// 알 수 없는 오류
    case unknownError
}

// MARK: - LocalizedError

extension NetworkError: LocalizedError {

    /// 사용자에게 표시할 에러 메시지
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL 형식입니다."
        case .invalidResponse:
            return "유효하지 않은 서버 응답입니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증에 실패했습니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 정보를 찾을 수 없습니다."
        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .decodingFailed:
            return "데이터 처리 중 오류가 발생했습니다."
        case .networkFailure(let error):
            return "네트워크 연결에 실패했습니다: \(error.localizedDescription)"
        case .timeout:
            return "요청 시간이 초과되었습니다. 다시 시도해주세요."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
