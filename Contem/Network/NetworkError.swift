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
