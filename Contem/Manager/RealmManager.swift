//
//  RealmManager.swift
//  Contem
//
//  Created by 이상민 on 11/28/25.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()

    private let realm: Realm

    private init() {
        do {
            realm = try Realm()
            print("Realm Path: \(realm.configuration.fileURL?.absoluteString ?? "N/A")")
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    // Generic write transaction
    func write<T: Object>(_ object: T, update: Realm.UpdatePolicy = .modified) throws {
        try realm.write {
            realm.add(object, update: update)
        }
    }
    
    // Batch write transaction
    func write<T: Object>(_ objects: [T], update: Realm.UpdatePolicy = .modified) throws {
        try realm.write {
            realm.add(objects, update: update)
        }
    }

    // Get all messages for a specific room, sorted by date
    func getMessages(for roomId: String) -> Results<ChatMessageObject> {
        return realm.objects(ChatMessageObject.self)
            .where { $0.roomId == roomId }
            .sorted(byKeyPath: "createdAt", ascending: true)
    }

    // Get the latest message for a specific room
    func getLatestMessage(for roomId: String) -> ChatMessageObject? {
        return getMessages(for: roomId).last
    }
    
    // Delete all objects of a certain type
    func deleteAll<T: Object>(ofType type: T.Type) throws {
        try realm.write {
            let objects = realm.objects(type)
            realm.delete(objects)
        }
    }
    
    // Delete all data from Realm
    func reset() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
