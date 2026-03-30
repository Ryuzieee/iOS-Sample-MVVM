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
        try store.getAllFavorites()
    }

    func isFavorite(id: Int) async throws -> Bool {
        try store.isFavorite(id: id)
    }

    func addFavorite(detail: PokemonDetailModel) async throws {
        try store.addFavorite(detail: detail)
    }

    func removeFavorite(id: Int) async throws {
        try store.removeFavorite(id: id)
    }
}
