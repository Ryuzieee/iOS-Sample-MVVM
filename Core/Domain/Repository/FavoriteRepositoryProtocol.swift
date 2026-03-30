//
//  FavoriteRepositoryProtocol.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// お気に入りデータへのアクセスを抽象化するリポジトリインターフェース。
protocol FavoriteRepositoryProtocol {
    func getFavorites() async throws -> [FavoriteModel]
    func isFavorite(id: Int) async throws -> Bool
    func addFavorite(detail: PokemonDetailModel) async throws
    func removeFavorite(id: Int) async throws
}
