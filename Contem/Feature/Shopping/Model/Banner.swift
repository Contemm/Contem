import Foundation

struct BannerList {
    let banners: [Banner]
    
    init(from dto: PostListDTO) {
        self.banners = dto.data.map { Banner(from: $0) }
    }
}

struct Banner {
    let id: String
    let title: String
    let subtitle: String
    let thumbnail: String
    
    var imageUrl: URL? {
        let fullUrl = APIConfig.baseURL + thumbnail
        return URL(string: fullUrl)
    }
    
    // DTO로 부터 생성
    init(from dto: PostDTO) {
        self.id = dto.postID
        self.title = "\(dto.title ?? "")\n\(dto.content ?? "")"
        self.subtitle = dto.value1 ?? ""
        self.thumbnail = dto.files.first ?? ""
    }
    
    // 목업용 직접 생성자 추가
    init(title: String, subtitle: String, thumbnail: String) {
        self.id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
    }
}
