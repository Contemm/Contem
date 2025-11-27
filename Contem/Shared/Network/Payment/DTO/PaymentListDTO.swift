import Foundation

struct PaymentListDto: Codable {
    let data: [PaymentValidationDTO]
}

struct PaymentValidationDTO: Codable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
