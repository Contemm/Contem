import Foundation

struct ShoppingProductList {
    let products: [ShoppingProduct]
    
    init(from dto: PostListDTO) {
        self.products = dto.data.map { ShoppingProduct(from: $0) }
    }
}

struct ShoppingProduct: Identifiable {
    let id: String
    let thumbnailUrl: String
    let brandName: String
    let productName: String
    let price: Int
    
    var imageUrl: URL? {
        let fullUrl = APIConfig.baseURL + thumbnailUrl
        return URL(string: fullUrl)
    }
    
    init(from dto: PostDTO) {
        self.id = dto.postID
        self.thumbnailUrl = dto.files.first ?? ""
        self.brandName = dto.title ?? ""
        self.productName = dto.content ?? ""
        self.price = dto.price ?? 0
    }
    
    
    
    init(thumbnailUrl: String, brandName: String, productName: String, price: Int) {
        self.id = UUID().uuidString
        self.thumbnailUrl = thumbnailUrl
        self.brandName = brandName
        self.productName = productName
        self.price = price
    }
}



struct ShoppingProductMock: Identifiable {
  let id = UUID()
  let brand: String
  let name: String
  let price: Int
  let imageName: String
}
