//
//  FeedSearchBarView.swift
//  Contem
//
//  Created by HyoTaek on 11/13/25.
//

import SwiftUI

struct FeedSearchBarView: View {
    
    // MARK: - Properties
    
    @State private var searchText = ""
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 0){
            HStack {
                TextField("", text: $searchText, prompt: Text("브랜드, 상품, 프로필, 태그 등")
                    .font(.bodyRegular)
                    .foregroundColor(.gray300)
                )
                .font(.bodyRegular)
                
                Spacer()
            }//: HSTACK
            .padding(.horizontal(16))
            .padding(.vertical(12))
            .background(.gray50)
            .cornerRadiusSmall()
            .padding(.horizontal(16))
            
            Button {
                print("피드 생성")
            } label: {
                Image(systemName: "camera.fill")
                    .foregroundStyle(.primary100)
            }
            .padding(.trailing, .spacing16)
        }//: HSTACK
    }
}
