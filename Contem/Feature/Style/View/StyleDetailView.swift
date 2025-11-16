//
//  StyleDetailView.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import SwiftUI

struct StyleDetailView: View {
    
    //MARK: - Properties
    @State private var selectedPage = 0
    
    //MARK: - Body
    var body: some View {
        NavigationStack{
            VStack(spacing: .spacing16){
                //MARK: - 상단 이미지 슬라이더
                TabView(selection: $selectedPage) {
                    ForEach(1...3, id: \.self) { index in
                        Image("look\(index)")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .tag(index)
                    }//: LOOP
                }//: TABVIEW
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                
                VStack(spacing: .spacing16){
                    HStack(spacing: .spacing16){
                        Spacer()
                        //좋아요
                        HStack(spacing: .spacing8){
                            Button {
                                print("좋아요 버튼 클릭")
                            } label: {
                                Image(systemName: "heart")
                            }
                            
                            Text("24k")
                                .foregroundStyle(.primary100)
                        }//: HSTACK
                        
                        //댓글
                        HStack(spacing: .spacing8){
                            Button {
                                print("댓글 버튼 클릭")
                            } label: {
                                Image(systemName: "message")
                            }
                            
                            Text("248")
                                .foregroundStyle(.primary100)
                        }//: HSTACK
                    }//: HSTACK
                    .foregroundStyle(.gray500)
                    .font(.bodyMedium)
                    .padding(.horizontal(.spacing16))
                    
                    //구분선
                    Divider()
                        .foregroundStyle(.gray100)
                    
                    VStack(alignment: .leading, spacing: .spacing8){
                        //제목
                        Text("The Bold and The Simple")
                            .foregroundStyle(.primary100)
                            .font(.titleMedium)
                        
                        //내용
                        Text("Weave them together or wear them separately, it’s your call. Day or night, this is your look.")
                            .foregroundStyle(.gray700)
                            .font(.bodyLarge)
                    }//: VSTACK
                    .padding(.horizontal(.spacing16))
                    
                    //연관 상품
                    VStack(alignment: .leading, spacing: .spacing12){
                        Text("Shop the look")
                            .foregroundStyle(.primary100)
                            .font(.titleSmall)
                            .padding(.horizontal(.spacing16))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: .spacing16) {
                                ForEach(1...4, id: \.self){ index in
                                    Image("shop\(index)")
                                        .resizable()
                                        .scaledToFill()
                                        .background(.gray50)
                                        .frame(width: 100, height: 100)
                                        .cornerRadiusMedium()
                                        .clipped()
                                }//: LOOP
                            }//: LazyHStack
                            .padding(.horizontal(.spacing16))
                        }//: SCROLLVIEW
                        .frame(height: 100)
                    }//: VSTACK
                    
                }//: VSTACK
                .navigationTitle("LookBook")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("toolBar Left dismiss")
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("공유하기")
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }//: VSTACK
        }//: NAVIGATIONSTACK
    }
}

#Preview {
    StyleDetailView()
}
