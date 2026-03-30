//
//  FavoriteRepositoryImpl.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// FavoriteRepositoryProtocol の実装クラス。CoreData を使ってお気に入りを永続化する。
final class FavoriteRepositoryImpl: FavoriteRepositoryProtocol {
    private let store: FavoriteCoreDataStore

    init(store: FavoriteCoreDataStore) {
        self.store = store
    }

    func getFavorites() async throws -> [FavoriteModel] {
        try await handleLocal(
            query: { try self.store.getAllFavorites() },
            toModel: { $0 }
        )
    }

    func isFavorite(id: Int) async throws -> Bool {
        try await handleLocal(
            query: { try self.store.isFavorite(id: id) },
            toModel: { $0 }
        )
    }

    func addFavorite(detail: PokemonDetailModel) async throws {
        try await handleLocal(
            query: { try self.store.addFavorite(detail: detail) },
            toModel: { $0 }
        )
    }

    func removeFavorite(id: Int) async throws {
        try await handleLocal(
            query: { try self.store.removeFavorite(id: id) },
            toModel: { $0 }
        )
    }
}
