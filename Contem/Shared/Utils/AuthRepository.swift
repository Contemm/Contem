import Foundation

protocol AuthRepositoryType {
    func loginWithApple(idToken: String) async throws -> LoginDTO
}

final class AuthRepository: AuthRepositoryType {
    func loginWithApple(idToken: String) async throws -> LoginDTO {
        return try await NetworkService.shared.callRequest(
            router: UserRequest.appleLogin(token: idToken),
            type: LoginDTO.self
        )
    }
}
