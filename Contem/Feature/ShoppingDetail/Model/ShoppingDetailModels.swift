import Foundation

/// 쇼핑 상품 상세 정보 모델
struct ShoppingDetailInfo: Codable {
    let id: String // 상품 아이디
    let brandName: String // 브랜드 이름
    let price: Int // 가격
    let productName: String // 상품 이름
    let productNameEn: String // 상품 영어 이름
    let contentImages: [String] // 이미지들, :로 구분
    let contentDetailImages: String // 이미지들 : 로 구분
    let brandInfo: UserDTO
    let salePrice: String // 할인가
    let productInfo: String // 상품 정보 (판매자, 제조국, 제조연월, 소재)
    let sizeInfo: String // 사이즈 정보j
    let likes: [String]
    
    
    var contentImageUrls: [URL] {
        contentImages.map {
            let fullUrl = APIConfig.baseURL + $0
            return URL(string: fullUrl)!
        }
    }
    
    var productImages: [URL] { // 상품 상세
        contentDetailImages.split(separator: ":").map {
            let fullUrl = APIConfig.baseURL + String($0)
            return URL(string: fullUrl)!
        }
    }

    var discountedPrice: Int? {
        Int(salePrice)
    }

    var discountRate: Double {
        guard let discounted = discountedPrice else { return 0 }
        let discount = Double(price - discounted) / Double(price) * 100
        return discount
    }

//    static let sample = ShoppingDetailInfo(
//        post_id: "sample_post_001",
//        category: "아우터-패딩",
//        title: "노스페이스 웨이브 LT 온 자켓 그레이 - 25FW",
//        price: 218000,
//        content: "image_1:image_2:image_3:image_4",
//        files: [],
//        createdAt: "2025-10-19T03:05:03.422Z",
//        creator: BrandInfo(
//            user_id: "brand_northface_001",
//            nick: "The North Face",
//            profileImage: "image_5"
//        ),
//        value1: "214000",
//        value2: "㈜영원아웃도어, 베트남, 2025년 6월, 겉감: 나일론 100%\n안감: 폴리에스터 100%\n주머니감 : 폴리에스터 100%\n충전재(몸판,소매) : 폴리에스터 100%",
//        value3: "(85(XS), 62, 111, 109, 49, 57, 18), (90(S), 65, 116, 112, 51, 59, 19), (95(M), 68, 121, 116, 53, 61, 20), (100(L), 70, 126, 121, 55, 62, 21), (105(XL), 72, 131, 126, 57, 63.5, 22), (110(XXL), 74, 136, 131, 59, 65, 23)"
//    )
    
    
    init(from dto: PostDTO) {
        self.id = dto.postID // 상품 아이디
        self.brandName = dto.title // 브랜드 이름
        self.price = dto.price // 가격
        self.productName = dto.content // 상품 이름
        self.productNameEn = dto.value4 // 상품 영어 이름
        self.contentImages = dto.files // 상품 베너 이미지
        self.contentDetailImages = dto.value1 // 상세 이미지
        self.salePrice = dto.value2 // 할인 가격
        self.productInfo = dto.value3 // 상품 정보 상세
        self.sizeInfo = dto.value5 // 사이즈 정보
        self.brandInfo = dto.creator // 브랜드 정보
        self.likes = dto.likes // 좋아요 정보
    }
}

/// 브랜드 정보 모델
struct BrandInfo: Codable {
    let userId: String
    let usernmae: String
    let profileImage: String
}
