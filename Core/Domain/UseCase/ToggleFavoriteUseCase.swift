//
//  ToggleFavoriteUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// お気に入りをトグルするユースケース。
final class ToggleFavoriteUseCase {
    private let repository: FavoriteRepositoryProtocol

    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }

    func execute(detail: PokemonDetailModel, isFavorite: Bool) async throws {
        if isFavorite {
            try await repository.removeFavorite(id: detail.id)
        } else {
            try await repository.addFavorite(detail: detail)
        }
    }
}
