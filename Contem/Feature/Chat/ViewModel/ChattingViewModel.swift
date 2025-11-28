//
//  ChattingViewModel.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation
import Combine
import Realm
import RealmSwift

final class ChattingViewModel: ViewModelType {
    
    //MARK: -  Properties
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        let appear = PassthroughSubject<Void, Never>()
        let sendMessage = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var messages: Results<ChatMessageObject>?
        var currentUserId: String?
        var opponentNickname: String?
        var opponentProfileImage: String?
        var error: Error?
    }
    
    private let opponentId: String
    private var roomId: String?
    private var notificationToken: NotificationToken?

    init(opponentId: String) {
        self.opponentId = opponentId
        transform()
    }
    
    deinit {
        notificationToken?.invalidate()
        ChatSocketService.shared.disconnect()
    }
    
    func transform() {
        input.appear
            .sink { [weak self] in
                self?.initializeChatSession()
            }
            .store(in: &cancellables)
        
        input.sendMessage
            .sink { [weak self] content in
                self?.sendMessage(content: content)
            }
            .store(in: &cancellables)
    }
    
    private func initializeChatSession() {
        Task {
            do {
                async let userIdTask = TokenStorage.shared.getUserId()
                async let opponentProfileTask = NetworkService.shared.callRequest(router: UserProfileRequest.getOtherProfile(userId: opponentId), type: OtherProfileDTO.self)
                
                let (userId, opponentProfile) = (await userIdTask, try await opponentProfileTask)
                
                let chatRoomResponse = try await NetworkService.shared.callRequest(router: ChatRequest.chatRoom(opponentId: opponentId), type: ChatRoomDTO.self)
                let roomId = chatRoomResponse.roomId
                self.roomId = roomId
                
                await MainActor.run {
                    self.output.currentUserId = userId
                    self.output.opponentNickname = opponentProfile.nick
                    self.output.opponentProfileImage = opponentProfile.profileImage
                }
                
                let messages = RealmManager.shared.getMessages(for: roomId)
                await MainActor.run {
                    self.output.messages = messages
                }
                
                notificationToken = messages.observe { [weak self] changes in
                    self?.objectWillChange.send()
                }
                
                let latestTimestamp = RealmManager.shared.getLatestMessage(for: roomId)?.createdAt
                
                ChatSocketService.shared.onChatReceived = { [weak self] result in
                    switch result {
                    case .success(let dto):
                        let realmObject = dto.toRealmObject()
                        do {
                            try RealmManager.shared.write(realmObject, update: .modified)
                        } catch {
                            print("Failed to write received chat message to Realm: \(error)")
                        }
                    case .failure(let error):
                        print("Socket received an error: \(error)")
                    }
                }
                
                guard let token = await TokenStorage.shared.getAccessToken() else { return }
                try ChatSocketService.shared.connect(roomId: roomId, token: token)
                
                let cursorDate = latestTimestamp?.ISO8601Format() ?? ""
                let historyResponse = try await NetworkService.shared.callRequest(router: ChatRequest.fetchMessage(roomId: roomId, cursor_date: cursorDate), type: ChatListDTO.self)
                
                let realmObjects = historyResponse.data.map { $0.toRealmObject() }
                try RealmManager.shared.write(realmObjects, update: .modified)
                
            } catch {
                await MainActor.run {
                    self.output.error = NetworkError
                        .mapping(error: error, response: nil, data: nil)
                }
            }
        }
    }
    
    private func sendMessage(content: String) {
        guard let roomId = roomId else { return }
        
        Task {
            do {
                let router = ChatRequest.sendMessage(roomId: roomId, content: content, files: [])
                _ = try await NetworkService.shared.callRequest(router: router, type: ChatResponseDTO.self)
            } catch {
                await MainActor.run {
                    self.output.error = error
                }
            }
        }
    }
}

