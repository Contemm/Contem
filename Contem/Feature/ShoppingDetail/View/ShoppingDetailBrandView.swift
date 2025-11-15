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
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(brandInfo.profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(brandInfo.nick)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)

                    Text("브랜드 공식몰")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        onFollowTapped()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isFollowing ? "checkmark" : "plus")
                            .font(.system(size: 12, weight: .semibold))

                        Text(isFollowing ? "팔로잉" : "팔로우")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(isFollowing ? .black : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isFollowing ? Color.white : Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: isFollowing ? 1 : 0)
                    )
                    .cornerRadius(20)
                }
                .scaleEffect(isFollowing ? 1.05 : 1.0)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color.gray.opacity(0.05))
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
