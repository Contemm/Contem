import Foundation
import Kingfisher

struct MyImageDownloadRequestModifier: ImageDownloadRequestModifier {
    func modified(for request: URLRequest) -> URLRequest? {
        var modifiedRequest = request
        guard let accessToken = try? KeychainManager.shared.read(.accessToken) else { return nil }
        modifiedRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        modifiedRequest.setValue(APIConfig.sesacKey, forHTTPHeaderField: "SeSACKey")
        modifiedRequest.setValue(APIConfig.productID, forHTTPHeaderField: "ProductId")
        return modifiedRequest
    }
}
