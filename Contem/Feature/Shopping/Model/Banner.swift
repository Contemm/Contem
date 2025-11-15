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
    
    
    // DTO로 부터 생성
    init(from dto: PostDTO) {
        self.title = "\(dto.title ?? "")\n\(dto.content ?? "")"
        self.subtitle = dto.value1 ?? ""
        self.thumbnail = dto.files.first ?? ""
    }
    
    // 목업용 직접 생성자 추가
    init(title: String, subtitle: String, thumbnail: String) {
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
    }
}
