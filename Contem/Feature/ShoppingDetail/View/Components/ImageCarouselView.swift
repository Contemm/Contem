//
//  ImageCarouselView.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI

/// 상품 이미지 캐러셀 뷰 (간소화 버전)
struct ImageCarouselView: View {

    // MARK: - Properties

    let imageNames: [String]
    @State private var currentIndex: Int = 0

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // 이미지 캐러셀
            TabView(selection: $currentIndex) {
                ForEach(Array(imageNames.enumerated()), id: \.offset) { index, imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 400)

            // 페이지 인디케이터
            HStack(spacing: 8) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Preview

#Preview {
    ImageCarouselView(
        imageNames: ["ItemImage1", "ItemImage2", "ItemImage3", "ItemImage4"]
    )
}
