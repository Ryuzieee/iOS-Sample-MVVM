//
//  GetIsFavoriteUseCase.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// 指定ポケモンがお気に入りかどうかを取得するユースケース。
final class GetIsFavoriteUseCase {
    private let repository: FavoriteRepositoryProtocol

    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Bool {
        try await repository.isFavorite(id: id)
    }
}
