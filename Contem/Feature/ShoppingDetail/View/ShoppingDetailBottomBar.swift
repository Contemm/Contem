//
//  ShoppingDetailBottomBar.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI

struct ShoppingDetailBottomBar: View {

    // MARK: - Properties

    let detailInfo: ShoppingDetailInfo
    let isLiked: Bool
    let selectedSize: String?
    let onLikeTapped: () -> Void
    let onShareTapped: () -> Void
    let onSizeSelectionTapped: () -> Void
    let onPurchaseTapped: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: .spacing12) {
                // Like Button
                Button(action: onLikeTapped) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.titleMedium)
                        .foregroundColor(isLiked ? .red : .primary100)
                        .frame(width: 44, height: 44)
                }

                // Share Button
                Button(action: onShareTapped) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.titleMedium)
                        .foregroundColor(.primary100)
                        .frame(width: 44, height: 44)
                }

                // Size Selection Button
                Button(action: onSizeSelectionTapped) {
                    HStack {
                        Text(selectedSize != nil ? "사이즈 \(selectedSize!)" : "사이즈 선택")
                            .font(.bodyMedium)
                            .foregroundColor(.primary100)

                        Image(systemName: "chevron.down")
                            .font(.captionSmall)
                            .foregroundColor(.gray500)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(.primary0)
                    .overlay(
                        RoundedRectangle(cornerRadius: .radiusSmall)
                            .stroke(.gray100, lineWidth: 1)
                    )
                    .cornerRadius(.radiusSmall)
                }

                // Purchase Button
                Button(action: onPurchaseTapped) {
                    Text("구매하기")
                        .font(.titleSmall)
                        .foregroundColor(.primary0)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(.primary100)
                        .cornerRadius(.radiusSmall)
                }
            }
            .padding(.horizontal, .spacing16)
            .padding(.vertical, .spacing12)
            .background(.primary0)
        }
        .background(.primary0)
        .shadow(color: .primary100.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

#Preview {
    ShoppingDetailBottomBar(
        detailInfo: ShoppingDetailInfo.sample,
        isLiked: false,
        selectedSize: nil,
        onLikeTapped: {},
        onShareTapped: {},
        onSizeSelectionTapped: {},
        onPurchaseTapped: {}
    )
}
