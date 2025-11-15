//
//  ShoppingDetailModels.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import Foundation

// MARK: - ShoppingDetailInfo

/// 쇼핑 상품 상세 정보 모델
struct ShoppingDetailInfo: Codable {
    let post_id: String
    let category: String
    let title: String
    let price: Int
    let content: String // 이미지들, :로 구분
    let files: [String] // 상세 이미지 파일들
    let createdAt: String
    let creator: BrandInfo
    let value1: String // 할인가
    let value2: String // 상품 정보 (판매자, 제조국, 제조연월, 소재)
    let value3: String // 사이즈 정보
    
    var contentImages: [String] {
        content.split(separator: ":").map { String($0) }
    }

    var discountedPrice: Int? {
        Int(value1)
    }

    var discountRate: Double {
        guard let discounted = discountedPrice else { return 0 }
        let discount = Double(price - discounted) / Double(price) * 100
        return discount
    }

    static let sample = ShoppingDetailInfo(
        post_id: "sample_post_001",
        category: "아우터-패딩",
        title: "노스페이스 웨이브 LT 온 자켓 그레이 - 25FW",
        price: 218000,
        content: "image_1:image_2:image_3:image_4",
        files: [],
        createdAt: "2025-10-19T03:05:03.422Z",
        creator: BrandInfo(
            user_id: "brand_northface_001",
            nick: "The North Face",
            profileImage: "image_5"
        ),
        value1: "214000",
        value2: "㈜영원아웃도어, 베트남, 2025년 6월, 겉감: 나일론 100%\n안감: 폴리에스터 100%\n주머니감 : 폴리에스터 100%\n충전재(몸판,소매) : 폴리에스터 100%",
        value3: "(85(XS), 62, 111, 109, 49, 57, 18), (90(S), 65, 116, 112, 51, 59, 19), (95(M), 68, 121, 116, 53, 61, 20), (100(L), 70, 126, 121, 55, 62, 21), (105(XL), 72, 131, 126, 57, 63.5, 22), (110(XXL), 74, 136, 131, 59, 65, 23)"
    )
}

// MARK: - BrandInfo

/// 브랜드 정보 모델
struct BrandInfo: Codable {
    let user_id: String
    let nick: String
    let profileImage: String
}
