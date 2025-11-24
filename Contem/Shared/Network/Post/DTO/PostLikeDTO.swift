import Foundation


struct PostLikeDTO: Codable {
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case isLiked = "like_status"
    }
}
