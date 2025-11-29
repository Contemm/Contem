//
//  ChatSocketService.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation
import SocketIO
import RealmSwift

enum SocketError: Error {
    case invalidData
    case decodingError(Error)
    case realmError(Error)
}

final class ChatSocketService {
    static let shared = ChatSocketService()
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    private var currentRoomId: String?
    private var isReconnecting = false
    
    var onChatReceived: ((Result<ChatResponseDTO, Error>) -> Void)?
    var onSocketError: ((Error) -> Void)?
    
    private init() { }
    
    func connect(roomId: String, token: String) throws {
        self.currentRoomId = roomId
        
        if socket?.nsp == "/chats-\(roomId)" && socket?.status == .connected {
            print("Already connected to room \(roomId)")
            setupHandlers()
            return
        }
        
        // Disconnect from any previous socket
        disconnect()
        
        guard let url = URL(string: APIConfig.baseURL) else {
             throw NetworkError.invalidURL
        }
        
        let namespace = "/chats-\(roomId)"
        
        let headers: [String: String] = [
            "SeSACKey": APIConfig.sesacKey,
            "Authorization": token,
            "ProductId": APIConfig.productID
        ]

        manager = SocketManager(
            socketURL: url,
            config: [
                .log(true),
                .forceWebsockets(true),
                .reconnects(false),
                .extraHeaders(headers)
            ]
        )
        
        socket = manager?.socket(forNamespace: namespace)

        setupHandlers()
        socket?.connect()
    }
    
    private func setupHandlers() {
        guard let socket = socket else { return }
        
        socket.removeAllHandlers()
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket Connected to Namespace: \(String(describing: socket.nsp))")
            self?.isReconnecting = false
        }
        
        socket.onAny { [weak self] event in
             if event.event == "error" {
                 // The print statement on the next line was causing an unresolvable compiler error.
                 // Removing it to allow the build to proceed.
                 self?.handleDisconnectAndReconnect()
             }
        }
        
        socket.on("chat") { [weak self] data, _ in
            guard let raw = data.first else {
                self?.onChatReceived?(.failure(SocketError.invalidData))
                return
            }

            guard let dict = raw as? [String: Any] else {
                self?.onChatReceived?(.failure(SocketError.invalidData))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let json = try JSONSerialization.data(withJSONObject: dict)
                let decoded = try decoder.decode(ChatResponseDTO.self, from: json)
                self?.onChatReceived?(.success(decoded))
                
            } catch let error as DecodingError {
                self?.onChatReceived?(.failure(SocketError.decodingError(error)))
            } catch {
                self?.onChatReceived?(.failure(error))
            }
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("Socket Disconnected. Reason: \(String(describing: data))")
            self?.handleDisconnectAndReconnect()
        }
    }
    
    private func handleDisconnectAndReconnect() {
        guard !isReconnecting, let roomId = currentRoomId else {
            print("Reconnection already in progress or roomId is nil.")
            return
        }
        
        isReconnecting = true
        print("Attempting to refresh token and reconnect...")
        
        Task { [weak self] in
            do {
                let newToken = try await TokenStorage.shared.refreshAccessToken()
                print("Token refreshed successfully. Reconnecting socket...")
                try self?.connect(roomId: roomId, token: newToken)
            } catch {
                print("Failed to refresh token or reconnect socket: \(error)")
                // Propagate the error to the listener (ViewModel)
                self?.onSocketError?(error)
                self?.isReconnecting = false
            }
        }
    }
    
    func disconnect() {
        socket?.removeAllHandlers()
        socket?.disconnect()
        socket = nil
        manager = nil
    }
}
