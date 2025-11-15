//
//  ShoppingDetailPriceView.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI

struct ShoppingDetailPriceView: View {

    // MARK: - Properties

    let detailInfo: ShoppingDetailInfo

    // MARK: - Body

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
                    Text("\(Int(detailInfo.discountRate))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(4)
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
    ShoppingDetailPriceView(detailInfo: ShoppingDetailInfo.sample)
}
