import AuthenticationServices
import Foundation

protocol AppleAuthServiceType {
    func signIn() async throws -> String
}


final class AppleAuthService: NSObject, AppleAuthServiceType {
    private var continuation: CheckedContinuation<String, Error>?
    
    @MainActor
    func signIn() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension AppleAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
               let identityTokenData = credential.identityToken,
               let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                
                // 성공 시 토큰 문자열 반환
                continuation?.resume(returning: identityTokenString)
            } else {
                continuation?.resume(throwing: URLError(.cannotParseResponse))
            }
            continuation = nil
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            continuation?.resume(throwing: error)
            continuation = nil
        }
}

extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
