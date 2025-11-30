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
                                print("채팅방 터치 \(room.id)")
                            } label: {
                                ChatRoomRow(chatRoom: room)
                            }.buttonStyle(.plain)

                            
                        }
                    }
                }.refreshable {
                    print("안녕")
                }
            } else {
                Text("대화중인 상대방이 없습니다.")
            }
            
        }.onAppear {
            viewModel.input.onAppearTrigger.send(())
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
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray)
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


