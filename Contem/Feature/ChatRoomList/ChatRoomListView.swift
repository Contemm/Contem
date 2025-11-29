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
        }.onAppear {
            viewModel.input.onAppearTrigger.send(())
        }
    }
    }


