import Foundation

struct ShoppingProductList {
    let products: [ShoppingProduct]
    
    init(from dto: PostListDTO) {
        self.products = dto.data.map { ShoppingProduct(from: $0) }
    }
}

struct ShoppingProduct: Identifiable, Equatable {
    let id: String
    let thumbnailUrl: String
    let brandName: String
    let productName: String
    let price: Int
    var likes: [String]
    
    
    private var currentUserId: String {
        return (try? KeychainManager.shared.read(.userId)) ?? ""
    }
    var isLiked: Bool {
        let userId = currentUserId
        guard !userId.isEmpty else { return false }
        return likes.contains(userId)
    }
    
    mutating func toggleLike() {
        let userId = currentUserId
        if isLiked {
            likes.removeAll { $0 == userId }
        } else {
            likes.append(userId)
        }
    }
    
    var imageUrl: URL? {
        let fullUrl = APIConfig.baseURL + thumbnailUrl
        return URL(string: fullUrl)
    }
    
    init(from dto: PostDTO) {
        self.id = dto.postID
        self.thumbnailUrl = dto.files.first ?? ""
        self.brandName = dto.title
        self.productName = dto.content
        self.price = dto.price
        self.likes = dto.likes
    }
    
    init(thumbnailUrl: String, brandName: String, productName: String, price: Int, likes: [String]) {
        self.id = UUID().uuidString
        self.thumbnailUrl = thumbnailUrl
        self.brandName = brandName
        self.productName = productName
        self.price = price
        self.likes = likes
    }
}
