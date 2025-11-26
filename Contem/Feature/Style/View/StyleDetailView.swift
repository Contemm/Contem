//
//  StyleDetailView.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import SwiftUI
import Kingfisher
import Combine

struct StyleDetailView: View {
    
    //MARK: - Properties
    @State private var selectedPage = 0
    @ObservedObject private var viewModel: StyleDetailViewModel
    
    init(viewModel: StyleDetailViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: .spacing16){
            if let style = viewModel.output.style{
                VStack(spacing: .spacing8){
                    HStack(spacing: .spacing8){
                        KFImage(style.creator.profileImageUrls)
                            .requestModifier(MyImageDownloadRequestModifier())
                            .placeholder { _ in
                                Circle()
                                    .fill(.gray50)
                            }
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading, spacing: .spacing4){
                            Text(style.creator.nick)
                                .font(.bodyMedium)
                            Text(style.createdAt.toKoreanDateFormat())
                                .font(.captionRegular)
                                .foregroundStyle(.gray900)
                        }//: VSTACK
                    }//: HSTACK
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal(.spacing16))
                    .onTapGesture {
                        viewModel.input.profileTapped.send(())
                    }
                    
                    //MARK: - 상단 이미지 슬라이더
                    TabView(selection: $selectedPage) {
                        ForEach(style.imageUrls.indices, id: \.self) { index in
                            GeometryReader { geometry in
                                ZStack{
                                    KFImage(style.imageUrls[index])
                                        .requestModifier(MyImageDownloadRequestModifier())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                    let tags = viewModel.output.tags[index] ?? []
                                    ForEach(tags, id: \.id){ tag in
                                        StyleTagLabel(text: "item")
                                            .position(x: geometry.size.width * tag.relX,
                                                      y: geometry.size.height * tag.relY)
                                    }
                                }//: ZSTACK
                                .clipped()
                            }//: GeometryReader
                            .tag(index)
                        }//: LOOP
                    }//: TABVIEW
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                }//: VSTACK
                .padding(.top, .spacing8)
                
                VStack(spacing: .spacing16){
                    HStack(spacing: .spacing16){
                        Spacer()
                        //좋아요
                        HStack(spacing: .spacing8){
                            Button {
                                viewModel.input.likebuttonTapped.send(())
                            } label: {
                                Image(systemName: viewModel.output.isStyleLiked ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.output.isStyleLiked ? .red : .gray500)
                            }
                            
                            Text(style.likeCount)
                                .foregroundStyle(.primary100)
                                .monospaced()
                                .font(.bodyRegular)
                        }//: HSTACK
                        
                        //댓글
                        HStack(spacing: .spacing8){
                            Button {
                                viewModel.input.commentButtonTapped.send(())
                            } label: {
                                Image(systemName: "message")
                            }
                            
                            Text("\(style.commentCount)")
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
                        Text(style.title ?? "...")
                            .foregroundStyle(.primary100)
                            .font(.titleMedium)
                        
                        //내용
                        Text(style.content ?? "...")
                            .foregroundStyle(.gray700)
                            .font(.bodyLarge)
                    }//: VSTACK
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            }else{
                if viewModel.output.isLoading{
                    ProgressView()
                }else if let error = viewModel.output.errorMessage{
                    Text("Error \(error)")
                }
            }
        }//: VSTACK
        .background()
        .onAppear(perform: {
            viewModel.input.appear.send(())
        })
        .navigationTitle("LookBook")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("공유하기")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }//: TOOLBAR
    }
}
