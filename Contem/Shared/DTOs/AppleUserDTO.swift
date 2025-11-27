import Foundation

struct AppleUserDTO: Identifiable, Sendable {
    let id: String
    let email: String?
    let fullName: PersonNameComponents?
    let identityToken: Data?
    let authorizationCode: Data?
}
