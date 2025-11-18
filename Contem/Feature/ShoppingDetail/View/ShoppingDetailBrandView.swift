//
//  ShoppingDetailBrandView.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI

struct ShoppingDetailBrandView: View {

    // MARK: - Properties

    let brandInfo: BrandInfo
    let isFollowing: Bool
    let onFollowTapped: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing16) {
            HStack(spacing: .spacing12) {
                Image(brandInfo.profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .background(.primary0)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.gray100, lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: .spacing4) {
                    Text(brandInfo.nick)
                        .font(.titleSmall)
                        .foregroundColor(.primary100)

                    Text("브랜드 공식몰")
                        .font(.captionLarge)
                        .foregroundColor(.gray500)
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        onFollowTapped()
                    }
                }) {
                    HStack(spacing: .spacing4) {
                        Image(systemName: isFollowing ? "checkmark" : "plus")
                            .font(.captionLarge)

                        Text(isFollowing ? "팔로잉" : "팔로우")
                            .font(.captionLarge)
                    }
                    .foregroundColor(isFollowing ? .primary100 : .primary0)
                    .padding(.horizontal, .spacing16)
                    .padding(.vertical, .spacing8)
                    .background(isFollowing ? .primary0 : .primary100)
                    .overlay(
                        RoundedRectangle(cornerRadius: .radiusXLarge)
                            .stroke(.primary100, lineWidth: isFollowing ? 1 : 0)
                    )
                    .cornerRadius(.radiusXLarge)
                }
                .scaleEffect(isFollowing ? 1.05 : 1.0)
            }
            .padding(.horizontal, .spacing20)
        }
        .padding(.vertical, .spacing16)
        .background(.gray25)
    }
}

#Preview {
    ShoppingDetailBrandView(
        brandInfo: BrandInfo(
            user_id: "brand_northface_001",
            nick: "The North Face",
            profileImage: "BrandLogoImage"
        ),
        isFollowing: false,
        onFollowTapped: {}
    )
}
