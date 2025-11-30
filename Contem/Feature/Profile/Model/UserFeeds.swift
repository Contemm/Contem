import Foundation


struct UserFeedList {
    let userFeedList: [UserFeed]
    
    init(from dto: PostListDTO) {
        self.userFeedList = dto.data.map { UserFeed(from: $0) }
    }
}

struct UserFeed: Identifiable {
    let id: String
    let thumbnailUrl: String
    
    
    init(from dto: PostDTO) {
        self.id = dto.postID
        self.thumbnailUrl = dto.files.first ?? ""
    }
}
