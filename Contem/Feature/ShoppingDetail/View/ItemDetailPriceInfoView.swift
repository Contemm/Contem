import SwiftUI

struct ItemDetailPriceInfoView: View {
    let detailInfo: DetailInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("원가")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("\(detailInfo.price.formatted())원")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .strikethrough()

                if detailInfo.discountRate > 0 {
                    DiscountBadge(discountRate: detailInfo.discountRate)
                }
            }

            if let discountedPrice = detailInfo.discountedPrice {
                Text("\(discountedPrice.formatted())원")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
            }

            Text(detailInfo.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ItemDetailPriceInfoView(detailInfo: DetailInfo.sample)
}
