import Foundation

// MARK: - Interface (DIP)
protocol AuthRepositoryType {
    func loginWithApple(idToken: String) async throws -> LoginDTO
}

// MARK: - Implementation
final class AuthRepository: AuthRepositoryType {
    func loginWithApple(idToken: String) async throws -> LoginDTO {
        return try await NetworkService.shared.callRequest(
            router: UserRequest.appleLogin(token: idToken),
            type: LoginDTO.self
        )
    }
}
