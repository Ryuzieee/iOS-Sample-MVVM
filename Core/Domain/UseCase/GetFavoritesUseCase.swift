//
//  GetFavoritesUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// お気に入り一覧を取得するユースケース。
final class GetFavoritesUseCase {
    private let repository: FavoriteRepositoryProtocol

    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }

    func callAsFunction() async throws -> [FavoriteModel] {
        try await repository.getFavorites()
    }
}
