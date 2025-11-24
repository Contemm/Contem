////
////  MockShoppingDetailAPI.swift
////  Contem
////
////  Created by 송재훈 on 11/15/25.
////
//
//import Foundation
//
//// MARK: - MockShoppingDetailAPI
//
///// 목업 데이터를 반환하는 ShoppingDetailAPI (실제 네트워크 요청 없음)
//final class MockShoppingDetailAPI: ShoppingDetailAPIProtocol {
//
//    // MARK: - Method
//
//    /// 상품 상세 정보 조회 (목업 데이터 반환)
////    func fetchDetail(postId: String) async throws -> ShoppingDetailInfo {
////        // 네트워크 호출 시뮬레이션을 위한 약간의 딜레이
////        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
////
////        // postId에 따라 다른 샘플 데이터 반환
//////        return getMockData(for: postId)
////    }
//
//    // MARK: - Private Method
//
//    /// postId에 따른 목업 데이터 생성
////    private func getMockData(for postId: String) -> ShoppingDetailInfo {
////        switch postId {
////        case "1":
////            return ShoppingDetailInfo(
////                post_id: "1",
////                category: "아우터-패딩",
////                title: "Palace 퍼텍스 퀼팅 RS 재킷",
////                price: 930000,
////                content: "image_1:image_2:image_3:image_4",
////                files: [],
////                createdAt: "2025-11-01T10:30:00.000Z",
////                creator: BrandInfo(
////                    user_id: "brand_palace",
////                    nick: "Palace",
////                    profileImage: "image_5"
////                ),
////                value1: "890000",
////                value2: "㈜팔라스코리아, 영국, 2025년 9월, 겉감: 나일론 100%\n안감: 폴리에스터 100%\n충전재: 덕다운 80%, 페더 20%",
////                value3: "(S, 64, 115, 110, 50, 58, 19), (M, 68, 120, 115, 52, 60, 20), (L, 72, 125, 120, 54, 62, 21), (XL, 76, 130, 125, 56, 64, 22)"
////            )
////
////        case "2":
////            return ShoppingDetailInfo(
////                post_id: "2",
////                category: "상의-반팔티",
////                title: "[더블점핑][FW25] 모이프 그래픽 티셔츠",
////                price: 567000,
////                content: "image_2:image_3:image_4:image_5",
////                files: [],
////                createdAt: "2025-11-02T14:20:00.000Z",
////                creator: BrandInfo(
////                    user_id: "brand_moif",
////                    nick: "moif",
////                    profileImage: "image_6"
////                ),
////                value1: "540000",
////                value2: "㈜모이프, 한국, 2025년 10월, 겉감: 면 100%",
////                value3: "(S, 62, 72, 68, 45, 20), (M, 66, 74, 70, 47, 21), (L, 70, 76, 72, 49, 22)"
////            )
////
////        case "3":
////            return ShoppingDetailInfo(
////                post_id: "3",
////                category: "신발-스니커즈",
////                title: "조던 1 x 자이언 윌리엄슨 콜라보",
////                price: 210000,
////                content: "image_3:image_4:image_5:image_1",
////                files: [],
////                createdAt: "2025-11-03T09:15:00.000Z",
////                creator: BrandInfo(
////                    user_id: "brand_jordan",
////                    nick: "Jordan",
////                    profileImage: "image_7"
////                ),
////                value1: "198000",
////                value2: "나이키코리아, 베트남, 2025년 8월, 갑피: 천연피혁, 인조피혁\n중창: 합성수지\n밑창: 고무",
////                value3: "(240mm, 245mm, 250mm, 255mm, 260mm, 265mm, 270mm, 275mm, 280mm, 285mm, 290mm)"
////            )
////
////        case "4":
////            return ShoppingDetailInfo(
////                post_id: "4",
////                category: "상의-후드티",
////                title: "폴리테루 휴먼인텍스 추동 후디",
////                price: 164000,
////                content: "image_4:image_5:image_6:image_7",
////                files: [],
////                createdAt: "2025-11-04T16:45:00.000Z",
////                creator: BrandInfo(
////                    user_id: "brand_polyteru",
////                    nick: "Polyteru Human In...",
////                    profileImage: "image_1"
////                ),
////                value1: "155000",
////                value2: "㈜폴리테루, 한국, 2025년 9월, 겉감: 면 80%, 폴리에스터 20%",
////                value3: "(S, 62, 68, 65, 48, 22), (M, 66, 70, 68, 50, 23), (L, 70, 72, 71, 52, 24), (XL, 74, 74, 74, 54, 25)"
////            )
////
////        default:
////            // 기본 샘플 데이터 반환
////            return ShoppingDetailInfo.sample
////        }
////    }
//}
