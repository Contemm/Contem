import Foundation

struct UserDTO: Codable {
    let userID: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname = "nick"
        case profileImage
    }
}
