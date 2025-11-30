import SwiftUI
import Combine
import Kingfisher


struct ChatRoomListView: View {
    @StateObject private var viewModel: ChatRoomListViewModel
    
    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(
            wrappedValue: ChatRoomListViewModel(
                coordinator: coordinator,
            )
        )
    }
    
    var body: some View {
        VStack {
            if !viewModel.output.chatRoomList.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.output.chatRoomList) { room in
                            Button {
                                viewModel.input.chatRoomTapped.send(room.partnerId)
                            } label: {
                                ChatRoomRow(chatRoom: room)
                            }.buttonStyle(.plain)

                            
                        }
                    }
                }.refreshable {
                
                }
            } else {
                Text("대화중인 상대방이 없습니다.")
            }
            
        }.onAppear {
            viewModel.input.onAppearTrigger.send(())
        }
        .navigationBarBackButtonHidden(true)
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


struct ChatRoomRow: View {
    let chatRoom: ChatRoomEntity
    
    var body: some View {
        HStack(spacing: 12) {
            if chatRoom.partnerProfileImage == nil {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray)
            } else {
                KFImage(chatRoom.partnerProfileImage)
                    .requestModifier(MyImageDownloadRequestModifier())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(Circle()) 
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chatRoom.partnerName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(chatRoom.lastChatContent)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.primary0)
        .contentShape(Rectangle())
    }
}


