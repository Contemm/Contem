import SwiftUI

/// 접을 수 있는 아코디언 아이템 뷰 (간소화 버전)
struct AccordionItemView: View {

    // MARK: - Properties

    let title: String
    let content: String
    @State private var isExpanded: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.titleSmall)
                        .foregroundColor(.primary100)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.bodyRegular)
                        .foregroundColor(.gray500)
                }
                .padding(.horizontal, .spacing20)
                .padding(.vertical, .spacing16)
            }

            // 컨텐츠
            if isExpanded {
                VStack(alignment: .leading, spacing: .spacing8) {
                    Text(content)
                        .font(.bodyRegular)
                        .foregroundColor(.gray500)
                        .lineSpacing(.spacing4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, .spacing20)
                .padding(.vertical, .spacing16)
                .background(.gray50)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // 구분선
            Divider()
                .background(.gray100)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        AccordionItemView(
            title: "상품 정보",
            content: "㈜영원아웃도어, 베트남, 2025년 6월, 겉감: 나일론 100%\n안감: 폴리에스터 100%\n주머니감 : 폴리에스터 100%\n충전재(몸판,소매) : 폴리에스터 100%"
        )
        AccordionItemView(
            title: "배송 정보",
            content: "배송비: 무료배송\n배송기간: 2-3일 소요"
        )
        AccordionItemView(
            title: "교환/반품 안내",
            content: "교환 및 반품은 상품 수령 후 7일 이내 가능합니다."
        )
        Spacer()
    }
}
