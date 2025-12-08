//
//  NetworkError.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL //URL 생성 실패
    case serverError(message: String) //서버에서 내려준 구체적인 에러 메시지
    case statusCodeError(type: StatusCodeError) //HTTP 상태 코드 에러(400, 401, 418 등)
    case notConnectedToInternet //인터넷 연결 없음
    case networkFailure(Error) // 그 외 통신 에러(DNS, SSL 등)
    case timeOut //요청 시간 초과
    case decodingFailed //데이터 디코딩 실패
    case invalidResponse //응답에 HTTPURLResponse가 아닌 경우
    case unknown(Error?) //알 수 없는 에러
    
    var errorDescription: String?{
        switch self {
        case .invalidURL:
            return "잘못된 URL 형식입니다."
        case .serverError(let message):
            return message
        case .statusCodeError(let type):
            return type.errorDescription
        case .notConnectedToInternet:
            return "네트워크 연결이 원활하지 않습니다/\nWi-Fi 또는 데이터 상태를 확인해주세요."
        case .timeOut:
            return "요청 시간이 초과되었습니다."
        case .decodingFailed:
            return "데이터 처리에 실패했습니다"
        case .invalidResponse:
            return "유효하지 않은 서버 응답입니다."
        case .networkFailure(let error):
            return "네트워크 연결 실패\n잠시 후 다시 시도해주세요.\n(\(error.localizedDescription)"
        case .unknown(let error):
            return "알 수 없는 오류가 발생했습니다.\(error?.localizedDescription ?? "")"
        }
    }
}

enum StatusCodeError: LocalizedError, Equatable{
    case badRequest //400
    case unauthorized(String? = nil) // 401
    case forbidden(String? = nil) //403
    case notFound //404
    case refreshTokenExpired(String? = nil) //418
    case accessTokenExpired(String? = nil)  // 419
    case serverError //500
    case other(code: Int) //그 외
    
    var errorDescription: String?{
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized(let message):
            return message ?? "인증 정보가 유효하지 않습니다"
        case .forbidden(let message):
            return message ?? "접근 권한이 없습니다."
        case .notFound:
            return "요청한 정보를 찾을 수 없습니다."
        case .refreshTokenExpired(let message):
            return message ?? "로그인 세션이 만료되었습니다.\n다시 로그인 해주세요."
        case .accessTokenExpired(let message):
            return message ?? "액세스 토큰이 만료되었습니다."
        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .other(let code):
            return "오류가 발생했습니다. (코드: \(code)"
        }
    }
}

extension NetworkError{
    static func mapping(error: Error?, response: URLResponse?, data: Data?) -> NetworkError{
        
        var serverMessage: String? = nil
        if let data = data,
           let result = try? JSONDecoder().decode(ServerErrorDTO.self, from: data) {
            serverMessage = result.message
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 401: return .statusCodeError(type: .unauthorized(serverMessage))
            case 403: return .statusCodeError(type: .forbidden(serverMessage))
            case 418: return .statusCodeError(type: .refreshTokenExpired(serverMessage))
            case 419: return .statusCodeError(type: .accessTokenExpired(serverMessage))
            default: break
            }
        }
        
        if let message = serverMessage {
            return .serverError(message: message)
        }
        
        if let httpResponse = response as? HTTPURLResponse{
            if !(200..<300).contains(httpResponse.statusCode){
                return .statusCodeError(
                    type: .codeMapping(code: httpResponse.statusCode)
                )
            }
        }
        
        if let urlError = error as? URLError{
            switch urlError.code{
            case .notConnectedToInternet:
                return .notConnectedToInternet
            case .timedOut:
                return .timeOut
            default:
                return .unknown(urlError)
            }
        }
        
        return .unknown(error)
    }
}

extension StatusCodeError{
    static func codeMapping(code: Int) -> StatusCodeError{
        switch code{
        case 400: return .badRequest
        case 401: return .unauthorized()
        case 403: return .forbidden()
        case 404: return .notFound
        case 418: return .refreshTokenExpired()
        case 419: return .accessTokenExpired()
        case 500...599: return .serverError
        default: return .other(code: code)
        }
    }
}
