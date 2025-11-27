//
//  ChatSocketService.swift
//  Contem
//
//  Created by 이상민 on 11/27/25.
//

import Foundation
import SocketIO

final class ChatSocketService {
    static let shared = ChatSocketService()
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    var onChatReceived: ((ChatMessageEntity) -> Void)?
    var onSocketError: ((Error) -> Void)?
    
    private init() { }
    
    func connect(roomId: String, token: String) throws {
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
                .reconnects(true),
                .reconnectAttempts(-1),
                .reconnectWait(1),
                .extraHeaders(headers)
            ]
        )
        
        socket = manager?.socket(forNamespace: namespace)

        setupHandlers()
        socket?.connect()
    }
    
    private func setupHandlers() {
        guard let socket = socket else { return }
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket Connected to Namespace")
        }
        
        socket.onAny { event in
             if event.event == "error" {
                 let error = NSError(domain: "SocketError", code: 0, userInfo: ["data": event.items ?? []])
                 self.onSocketError?(error)
             }
        }
        
        socket.on("chat") { [weak self] data, _ in
            guard let raw = data.first else {
                return
            }

            guard let dict = raw as? [String: Any] else {
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let json = try? JSONSerialization.data(withJSONObject: dict),
                  let decoded = try? decoder.decode(ChatResponseDTO.self, from: json) else {
                return
            }
            
            let response = decoded.toEntity()
            
            self?.onChatReceived?(response)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket Disconnected")
        }
    }
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
        manager = nil
    }
}
