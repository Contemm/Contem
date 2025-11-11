import Foundation

struct ShoppingProduct: Identifiable {
  let id = UUID()
  let brand: String
  let name: String
  let price: Int
  let imageName: String
}
