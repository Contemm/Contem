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

            HStack(spacing: 12) {
                // Like Button
                Button(action: onLikeTapped) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 22))
                        .foregroundColor(isLiked ? .red : .black)
                        .frame(width: 44, height: 44)
                }

                // Share Button
                Button(action: onShareTapped) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                }

                // Size Selection Button
                Button(action: onSizeSelectionTapped) {
                    HStack {
                        Text(selectedSize != nil ? "사이즈 \(selectedSize!)" : "사이즈 선택")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(8)
                }

                // Purchase Button
                Button(action: onPurchaseTapped) {
                    Text("구매하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
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
