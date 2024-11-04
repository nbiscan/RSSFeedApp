//
//  RSSFeedDataSource.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 19.10.2024..
//

import Foundation

protocol Storable: Codable {
    var identifier: String { get }
}

protocol LocalStorageDataSourceProtocol {
    associatedtype Entity: Storable
    func saveEntities(_ entities: [Entity])
    func loadEntities() -> [Entity]
    func updateEntity(_ entity: Entity)
}

final class LocalStorageDataSource<T: Storable>: LocalStorageDataSourceProtocol {
    typealias Entity = T
    private let storageKey: String
    private let userDefaults = UserDefaults.standard
    
    init(storageKey: String) {
        self.storageKey = storageKey
    }
    
    func saveEntities(_ entities: [T]) {
        if let data = try? JSONEncoder().encode(entities) {
            userDefaults.set(data, forKey: storageKey)
        }
    }
    
    func loadEntities() -> [T] {
        guard let data = userDefaults.data(forKey: storageKey),
              let entities = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return entities
    }
    
    func updateEntity(_ entity: T) {
        var entities = loadEntities()
        if let index = entities.firstIndex(where: { $0.identifier == entity.identifier }) {
            entities[index] = entity
            saveEntities(entities)
        }
    }
}
