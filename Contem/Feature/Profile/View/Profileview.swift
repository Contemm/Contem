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
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            if let profile = viewModel.output.profile{
                VStack(alignment: .leading, spacing: .spacing16){
                    HStack(spacing: .spacing16){
                        KFImage(profile.imageUrls)
                            .requestModifier(MyImageDownloadRequestModifier())
                            .placeholder { _ in
                                Circle()
                                    .fill(.gray50)
                            }
                            .frame(width: 80, height: 80)
                        
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
                            print("메시지 버튼 클릭")
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
            
            Spacer()
        }//: VSTACK
        .background(.gray50)
        .onAppear {
            viewModel.input.appear.send(())
        }
    }
}
//
//#Preview {
//    Profileview()
//}
