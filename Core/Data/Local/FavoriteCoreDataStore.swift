//
//  FavoriteCoreDataStore.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation
import CoreData

/// お気に入りストアのプロトコル。テスト時にモック差し替え可能。
protocol FavoriteStoreProtocol {
    func getAllFavorites() throws -> [FavoriteModel]
    func isFavorite(id: Int) throws -> Bool
    func addFavorite(detail: PokemonDetailModel) throws
    func removeFavorite(id: Int) throws
}

/// お気に入りポケモンの CRUD 操作を行う CoreData ストア。
final class FavoriteCoreDataStore: FavoriteStoreProtocol {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func getAllFavorites() throws -> [FavoriteModel] {
        let context = coreDataStack.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]

        let entities = try context.fetch(request)
        return entities.map { FavoriteMapper.toModel(from: $0) }
    }

    func isFavorite(id: Int) throws -> Bool {
        let context = coreDataStack.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
        request.predicate = NSPredicate(format: "id == %d", Int64(id))
        request.fetchLimit = 1

        let count = try context.count(for: request)
        return count > 0
    }

    func addFavorite(detail: PokemonDetailModel) throws {
        let context = coreDataStack.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "FavoriteEntity", into: context)
        FavoriteMapper.applyToEntity(entity, from: detail)
        try context.save()
    }

    func removeFavorite(id: Int) throws {
        let context = coreDataStack.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
        request.predicate = NSPredicate(format: "id == %d", Int64(id))

        let results = try context.fetch(request)
        for object in results {
            context.delete(object)
        }
        try context.save()
    }
}
