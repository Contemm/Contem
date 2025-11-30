import Foundation


struct UserFeedList {
    let userFeedList: [UserFeed]
    
    init(from dto: PostListDTO) {
        self.userFeedList = dto.data.map { UserFeed(from: $0) }
    }
}

struct UserFeed: Identifiable {
    let id: String
    let thumbnailUrl: URL?
    
    
    init(from dto: PostDTO) {
        self.id = dto.postID
        if let imageUrl = dto.files.first {
            self.thumbnailUrl = URL(string: APIConfig.baseURL + imageUrl)
        } else {
            self.thumbnailUrl = nil
        }
    }
}
