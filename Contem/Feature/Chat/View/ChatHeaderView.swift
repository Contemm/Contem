//
//  ChatHeaderView.swift
//  Contem
//
//  Created by 이상민 on 11/29/25.
//

import SwiftUI
import Kingfisher

struct ChatHeaderView: View {
    let nickname: String?
    let profileImage: URL?
    
    var body: some View {
        VStack(spacing: .spacing12) {
            KFImage(profileImage)
                .placeholder { _ in
                    Circle()
                        .fill(.gray50)
                }
                .frame(width: 80, height: 80)
                .clipShape(.circle)
            
            Text(nickname ?? "Loading...")
                .font(.titleSmall)
        }
        .padding(.vertical(.spacing16))
        .background(.clear)
    }
}
