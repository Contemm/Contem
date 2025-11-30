//
//  StyleTagLabel.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import SwiftUI
import Kingfisher

struct StyleTagLabel: View {
    let tag: StyleTag
    
    var body: some View {
        HStack(spacing: 8) {
            if let imageURL = tag.imageURL {
                KFImage(imageURL)
                    .requestModifier(MyImageDownloadRequestModifier())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .background(.primary0)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 30, height: 30)
            }
            
            VStack(alignment: .leading, spacing: .spacing4) {
                Text(tag.title ?? "-")
                    .font(.caption)
                    .foregroundColor(.gray300)
                
                if let price = tag.price {
                    Text("\(price)원")
                        .font(.caption2)
                        .foregroundColor(.white)
                }else{
                    Text("-")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
            }
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(.gray500)
        }
        .padding(.horizontal, .spacing8)
        .padding(.vertical, .spacing8)
        .background(Color.black.opacity(0.6))
        .cornerRadius(12)
    }
}

