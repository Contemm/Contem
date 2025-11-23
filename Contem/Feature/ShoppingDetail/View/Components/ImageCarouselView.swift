import SwiftUI
import Kingfisher

/// 상품 이미지 캐러셀 뷰 (간소화 버전)
struct ImageCarouselView: View {

    // MARK: - Properties

    let imageNames: [URL]
    @State private var currentIndex: Int = 0

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // 이미지 캐러셀
            TabView(selection: $currentIndex) {
                ForEach(Array(imageNames.enumerated()), id: \.offset) { index, imageName in
                    KFImage(imageName)
                        .requestModifier(MyImageDownloadRequestModifier())
                        .placeholder {
                            // 로딩 중에 보여줄 플레이스홀더 (UX 개선)
                            ProgressView()
                                .controlSize(.large)
                        }
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 400)

            // 페이지 인디케이터
            HStack(spacing: .spacing8) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? .primary100 : .gray100)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, .spacing12)
        }
    }
}

// MARK: - Preview

//#Preview {
//    ImageCarouselView(
//        imageNames: ["ItemImage1", "ItemImage2", "ItemImage3", "ItemImage4"]
//    )
//}
