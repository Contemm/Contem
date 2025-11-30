import Foundation
import Combine

final class ChatRoomListViewModel: ViewModelType {
    private weak var coordinator: AppCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    
    var input = Input()

    @Published var output = Output()
    
    
    struct Input {
        let dismissButtonTapped = PassthroughSubject<Void, Never>()
        let onAppearTrigger = PassthroughSubject<Void, Never>()
        let chatRoomTapped = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var chatRoomList: [ChatRoomEntity] = []
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        transform()
    }
    

    func transform() {
        input.onAppearTrigger
            .withUnretained(self)
            .sink { owner, _ in
                Task {
                    await owner.fetchChatRooms()
                }
            }.store(in: &cancellables)
        
        input.chatRoomTapped
            .withUnretained(self)
            .sink { owner, userId in
                owner.coordinator?.push(.creatorChat(opponentId: userId))
            }.store(in: &cancellables)
    }
}


// MARK: - 네트워크 관련
extension ChatRoomListViewModel {
    private func fetchChatRooms() async {
        do {
            let router = ChatRequest.chatRoomList
            let result = try await NetworkService.shared.callRequest(router: router, type: ChatRoomResponseListDTO.self)
            let chatRoomList = ChatRoomListEntity(from: result)
            await MainActor.run {
                output.chatRoomList = chatRoomList.roomList
            }
        } catch {
            print("에러 \(error.localizedDescription)")
        }
    }
}
