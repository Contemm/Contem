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
    
    var onChatReceived: ((Result<ChatResponseDTO, Error>) -> Void)?
    var onSocketError: ((Error) -> Void)?
    
    private init() { }
    
    func connect(roomId: String, token: String) throws {
        // Avoid reconnecting if already connected to the same room
        if socket?.nsp == "/chats-\(roomId)" && socket?.status == .connected {
            print("Already connected to room \(roomId)")
            setupHandlers() // Ensure handlers are set up even if not reconnecting
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
        
        // Remove existing handlers before adding new ones to prevent duplicates
        socket.removeAllHandlers()
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket Connected to Namespace: \(socket.nsp)")
        }
        
        socket.onAny { event in
             if event.event == "error" {
                 let error = NSError(domain: "SocketError", code: 0, userInfo: ["data": event.items ?? []])
                 self.onSocketError?(error)
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
