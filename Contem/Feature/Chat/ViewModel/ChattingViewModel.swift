//
//  ChattingViewModel.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation
import Combine

final class ChattingViewModel: ViewModelType{
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output: Output = Output()
    
    struct Input{
        let appear = PassthroughSubject<Void, Never>()
    }
    
    struct Output{
        var messages: [ChatMessageEntity] = []
    }
    
    private let opponentId: String
    
    private var isInitialLoading = true
    private var buffer: [ChatMessageEntity] = []
    
    init(opponentId: String){
        self.opponentId = opponentId
        observeSocket()
        transform()
    }
    
    deinit{
        ChatSocketService.shared.disconnect()
    }
    
    func transform() {
        input.appear
            .sink { [weak self] in
                guard let self else { return }
                Task { await self.initialLoad()}
            }
            .store(in: &cancellables)
    }
    
    private func observeSocket(){
        ChatSocketService.shared.onChatReceived = { [weak self] msg in
            guard let self else { return }
            
            if self.isInitialLoading{
                self.buffer.append(msg)
                return
            }
            
            self.output.messages.append(msg)
            self.output.messages.sort(by: { $0.createdAt < $1.createdAt })
        }
    }
    
    private func initialLoad() async{
        guard let token = await TokenStorage.shared.getAccessToken() else { return }
        
        do{
            let chatRoomResponse = try await NetworkService.shared.callRequest(router: ChatRequest.chatRoom(opponentId: opponentId), type: ChatRoomDTO.self)
            
            let roomId = chatRoomResponse.roomId
            
            let cursor = "2025-11-27T00:00:00Z"
            
            let response = try await NetworkService.shared.callRequest(router: ChatRequest.fetchMessage(roomId: roomId, cursor_date: cursor), type: ChatListDTO.self)
            
            var results = response.data.map{$0.toEntity()}
            results.append(contentsOf: buffer)
            results.sort(by: { $0.createdAt < $1.createdAt })
            
            output.messages = results
            
            buffer.removeAll()
            isInitialLoading = false
            
            try ChatSocketService.shared.connect(roomId: roomId, token: token)
        }catch{
            print(error)
        }
    }
}

