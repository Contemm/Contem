import SwiftUI

struct ShoppingDetailPriceView: View {
    let detailInfo: ShoppingDetailInfo

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing12) {
            HStack(spacing: .spacing8) {
                Text("원가")
                    .font(.bodyRegular)
                    .foregroundColor(.gray500)

                Text("\(detailInfo.originalPrice.formatted())원")
                    .font(.bodyRegular)
                    .foregroundColor(.gray500)
                    .strikethrough()

                if detailInfo.discountRate > 0 {
                    Text("\(Int(detailInfo.discountRate))%")
                        .font(.captionLarge)
                        .foregroundColor(.primary0)
                        .padding(.horizontal, .spacing8)
                        .padding(.vertical, .spacing4)
                        .background(Color.red)
                        .cornerRadius(.spacing4)
                }
            }
            
            Text("\(detailInfo.finalPrice.formatted())원")
                .font(.titleLarge)
                .foregroundColor(.primary100)

            VStack(alignment: .leading, spacing: CGFloat.spacing4) {
                Text(detailInfo.brandName)
                    .font(.titleSmall)
                    .foregroundColor(.primary100)
                
                Text(detailInfo.productName)
                    .font(.captionLarge)
                
                Text(detailInfo.productNameEn)
                    .font(.captionSmall)
            }
            
        }
        .padding(.horizontal, .spacing20)
        .padding(.vertical, .spacing16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
