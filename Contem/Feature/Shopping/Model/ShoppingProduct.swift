import Foundation

struct ShoppingProducts {
    let banners: [ShoppingProduct]
    
    init(from dto: PostListDTO) {
        self.banners = dto.data.map { ShoppingProduct(from: $0) }
    }
}

struct ShoppingProduct {
    let id: String
    let thumbnailUrl: String
    let brandName: String
    let productName: String
    let price: Int
    
    init(from dto: PostDTO) {
        self.id = dto.postID
        self.thumbnailUrl = dto.files.first ?? ""
        self.brandName = dto.title ?? ""
        self.productName = dto.content ?? ""
        self.price = dto.price ?? 0
    }
}



struct ShoppingProductMock: Identifiable {
  let id = UUID()
  let brand: String
  let name: String
  let price: Int
  let imageName: String
}
