import SwiftUI
import Combine



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
            Text("채팅방 리스트")
            ChatRoomRow()
            ChatRoomRow()
            ChatRoomRow()
        }.onAppear {
            viewModel.input.onAppearTrigger.send(())
        }
    }
}


struct ChatRoomRow: View {
    
    var body: some View {
        HStack(spacing: 12) { // 이미지와 텍스트 사이 간격
            
            // 1. 원형 유저 프로필 (시스템 이미지 사용)
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.gray) // 프로필 색상 (회색)
            
            // 2. 이름 및 마지막 메시지
            VStack(alignment: .leading, spacing: 4) {
                Text("홍길동") // 유저 네임
                    .font(.headline) // 조금 진하고 큰 폰트
                    .foregroundStyle(.primary)
                
                Text("안녕하세요, 오늘 저녁 시간 괜찮으신가요?") // 마지막 메시지
                    .font(.subheadline)
                    .foregroundStyle(.secondary) // 회색빛 보조 색상
                    .lineLimit(1) // 한 줄 넘어가면 ... 처리
            }
            
            Spacer() // 내용을 왼쪽으로 밀어주고 전체 너비를 채움
        }
        .padding(.vertical, 8) // 상하 여백 추가
        .padding(.horizontal, 16) // 좌우 여백 추가
    }
}


