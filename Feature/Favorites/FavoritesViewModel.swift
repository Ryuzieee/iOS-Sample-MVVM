//
//  FavoritesViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation

/// お気に入り一覧画面のViewModel。
@MainActor
final class FavoritesViewModel: ObservableObject, AsyncLoadable {
    @Published var content: UiState<[FavoriteModel]> = .loading
    var loadTask: Task<Void, Never>?

    var gridItems: [PokemonGridItem] {
        (content.dataOrNil ?? []).map {
            PokemonGridItem(id: $0.id, name: $0.name, imageUrl: $0.imageUrl)
        }
    }

    private let getFavoritesUseCase: GetFavoritesUseCase

    init(getFavoritesUseCase: GetFavoritesUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
    }

    deinit { cancelLoad() }

    func loadIfNeeded() {
        guard content.isLoading else { return }
        load()
    }

    func fetchContent(forceRefresh: Bool) async throws -> [FavoriteModel] {
        try await getFavoritesUseCase()
    }
}
