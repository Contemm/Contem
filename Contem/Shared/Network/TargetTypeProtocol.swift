//
//  TargetTypeProtocol.swift
//  Contem
//
//  Created by 이상민 on 11/18/25.
//

import Foundation

//MARK: - HTTPMethod
enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct MultipartFile{
    let name: String //서버 Key
    let filename: String
    let mimeType: String
    let data: Data
}

protocol TargetTypeProtocol{
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var multipartFiles: [MultipartFile]? { get }
    var hasAuthorization: Bool { get }
}

extension TargetTypeProtocol{
    var baseURL: String{
        return APIConfig.baseURL
    }
    
    var endPoint: String{
        return baseURL + path
    }
    
    var url: URL?{
        return URL(string: endPoint)
    }
    
    var hasAuthorization: Bool{
        return true
    }
}

extension TargetTypeProtocol{
    func asUrlRequest() throws(NetworkError) -> URLRequest{
        guard let url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)else {
            throw NetworkError.invalidURL
        }
        
        //GET -> Query
        if method == .get {
            var items: [URLQueryItem] = []
            
            for (key, value) in parameters{
                if let array = value as? [String]{
                    array.forEach {
                        items.append(URLQueryItem(name: key, value: $0))
                    }
                    continue
                }
                
                let stringValue = "\(value)"
                if stringValue.isEmpty{
                    continue
                }
                
                items.append(URLQueryItem(name: key, value: stringValue))
            }
            
            components.queryItems = items
        }
        
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        if hasAuthorization,
           let token = try? KeychainManager.shared.read(.accessToken){
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let files = multipartFiles,
           method == .post{
            let boundary = "Boundary-\(UUID().uuidString)"
            request
                .setValue(
                    "multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField: "Content-Type"
                )
            request.httpBody = createMultipartBody(
                parameters: parameters,
                files: files,
                boundary: boundary
            )
            
            return request
        }
        
        if method == .post || method == .put || method == .delete{
            if parameters.isEmpty == false{
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization
                    .data(withJSONObject: parameters)
            }
        }
        
        return request
    }
}

func createMultipartBody(
    parameters: [String: Any],
    files: [MultipartFile],
    boundary: String
) -> Data {
    
    var body = Data()
    let lineBreak = "\r\n"
    let boundaryPrefix = "--\(boundary)\r\n"
    
    // 텍스트 파라미터
    for (key, value) in parameters {
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    // 파일 파라미터
    for file in files {
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(file.data)
        body.append(lineBreak.data(using: .utf8)!)
    }
    
    // 종료 boundary
    body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
    
    return body
}
