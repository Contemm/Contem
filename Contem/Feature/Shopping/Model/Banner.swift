import Foundation

struct BannerList {
    let banners: [Banner]
    
    init(from dto: PostListDTO) {
        self.banners = dto.data.map { Banner(from: $0) }
    }
}

struct Banner {
    let title: String
    let subtitle: String
    let thumbnail: String
    
    init(from dto: PostDTO) {
        self.title = "\(dto.title ?? "")\n\(dto.content ?? "")"
        self.subtitle = dto.value1 ?? ""
        self.thumbnail = dto.files.first ?? ""
    }
}
