//
//  Profileview.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import SwiftUI
import Kingfisher
import Combine

struct Profileview: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(userId: String, coordinator: AppCoordinator) {
        _viewModel = StateObject(
            wrappedValue: ProfileViewModel(
                userId: userId,
                coordinator: coordinator
            )
        )
    }
    
    var body: some View {
        VStack{
//            Button("로그아웃") {
//                viewModel.input.logoutTapped.send(())
//            }
            
            if let profile = viewModel.output.profile{
                VStack(alignment: .leading, spacing: .spacing16){
                    HStack(spacing: .spacing16){
                        KFImage(profile.imageUrls)
                            .requestModifier(MyImageDownloadRequestModifier())
                            .resizable()
                            .placeholder { _ in
                                Circle()
                                    .fill(.gray50)
                            }
                            .scaledToFill()
                            .frame(width: 52, height: 52)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: .spacing8){
                            Text(profile.nick)
                                .font(.bodyMedium)
                            HStack(spacing: .spacing4){
                                Text("팔로워")
                                    .font(.captionRegular)
                                    .foregroundStyle(.gray900)
                                Text(profile.followerCount)
                                    .font(.captionLarge)
                                    .monospaced()
                                Text("|")
                                    .font(.captionRegular)
                                    .foregroundStyle(.gray900)
                                Text("팔로잉")
                                    .font(.captionRegular)
                                    .foregroundStyle(.gray900)
                                Text(profile.followingCount)
                                    .font(.captionLarge)
                                    .monospaced()
                            }//: HSTACK
                        }//: VSTACK
                    }//: HSTACK
                    Text(profile.info1)
                        .font(.bodyRegular)
                    
                    // 버튼
                    if !viewModel.output.isMyProfile {
                        HStack(spacing: .spacing16){
                            Button(action: {
                                viewModel.input.followButtonTapped.send(())
                            }, label: {
                                Text(viewModel.output.isFollowing ? "팔로잉" : "팔로우")
                                    .padding(.vertical(.spacing8))
                                    .frame(maxWidth: .infinity)
                                    .background(.primary100)
                                    .foregroundStyle(.primary0)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            })
                            
                            Button {
                                viewModel.input.messageButtonTapped.send(())
                            } label: {
                                Text("메시지")
                                    .padding(.vertical(.spacing8))
                                    .frame(maxWidth: .infinity)
                                    .background(.primary0)
                                    .foregroundStyle(.gray900)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray900, lineWidth: 1.0)
                                    )
                            }
                        }//: HSTACK
                        .buttonStyle(.plain)
                        .font(.captionRegular)
                    } else {
                        HStack(spacing: .spacing16) {
                            
                            Button(action: {
                                viewModel.input.logoutTapped.send(())
                            }, label: {
                                Text("로그아웃")
                                    .padding(.vertical(.spacing8))
                                    .frame(maxWidth: .infinity)
                                    .background(.primary100)
                                    .foregroundStyle(.primary0)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            })
                            
                            
                            Button {
                                viewModel.input.dmButtonTapped.send(())
                            } label: {
                                Text("디엠 목록")
                                    .padding(.vertical(.spacing8))
                                    .frame(maxWidth: .infinity)
                                    .background(.primary0)
                                    .foregroundStyle(.gray900)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray900, lineWidth: 1.0)
                                    )
                            }
                        }  .buttonStyle(.plain)
                            .font(.captionRegular)
                        
                    }
                    
                }//: VSTACK
                .padding(.vertical(.spacing16))
                .padding(.horizontal(.spacing16))
                .background(.primary0)
            }else{
                if viewModel.output.isLoading{
                    ProgressView()
                }else if let error = viewModel.output.errorMessage{
                    Text("Error \(error)")
                }
            }
            
            
            // 3x3 이미지 스크롤
            if !viewModel.output.userFeeds.isEmpty {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                        ForEach(viewModel.output.userFeeds, id: \.id) { feed in
                            Button {
                                viewModel.input.postTapped.send(feed.id)
                            } label: {
                                Rectangle()
                                    .fill(.clear)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        KFImage(feed.thumbnailUrl)
                                            .requestModifier(MyImageDownloadRequestModifier())
                                            .resizable()
                                            .placeholder {
                                                Rectangle().fill(.gray50)
                                            }
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    )
                                    .clipped()
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.top, 1) // 헤더와 그리드 사이 간격
            } else {
                Spacer()
                Text("작성하신 스타일이 없습니다")
                Spacer()
            }
        }//: VSTACK
        .background(.primary0)
        .onAppear {
            viewModel.input.appear.send(())
        }.navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // 뒤로가기 액션
                        // 만약 Coordinator로 pop 처리를 한다면:
                         viewModel.input.dismissButtonTapped.send(())
                    } label: {
                        Image(systemName: "chevron.left") // 화살표 이미지
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 20) // 적절한 크기 조절
                            .foregroundStyle(.black)      // 검정색 설정
                    }
                }
            }
    }
}

