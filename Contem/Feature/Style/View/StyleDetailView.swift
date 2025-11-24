//
//  StyleDetailView.swift
//  Contem
//
//  Created by 이상민 on 11/16/25.
//

import SwiftUI
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
            //MARK: - 상단 이미지 슬라이더
            TabView(selection: $selectedPage) {
                ForEach(viewModel.output.style.files.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        ZStack{
                            
                            Image(viewModel.output.style.files[index])
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
                        
                        Text(viewModel.output.style.likeCount)
                            .foregroundStyle(.primary100)
                    }//: HSTACK
                    
                    //댓글
                    HStack(spacing: .spacing8){
                        Button {
                            let testId = "691ee5849682593e05755005"
                            viewModel.input.commentButtonTapped.send(testId)
                        } label: {
                            Image(systemName: "message")
                        }
                        
                        Text("\(viewModel.output.style.commentCount)")
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
                    Text(viewModel.output.style.title)
                        .foregroundStyle(.primary100)
                        .font(.titleMedium)
                    
                    //내용
                    Text(viewModel.output.style.content)
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
        }//: VSTACK
    }
}
