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
final class FavoritesViewModel: ObservableObject {
    @Published var content: UiState<[FavoriteModel]> = .loading
    @Published var isRefreshing = false

    var gridItems: [PokemonGridItem] {
        (content.dataOrNil ?? []).map {
            PokemonGridItem(id: $0.id, name: $0.name, imageUrl: $0.imageUrl)
        }
    }

    private let getFavoritesUseCase: GetFavoritesUseCase
    private var loadTask: Task<Void, Never>?

    init(getFavoritesUseCase: GetFavoritesUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
    }

    deinit {
        loadTask?.cancel()
    }

    func loadIfNeeded() {
        guard case .loading = content else { return }
        load()
    }

    func retry() {
        load()
    }

    func refresh() {
        load(forceRefresh: true)
    }

    private func load(forceRefresh: Bool = false) {
        loadTask?.cancel()
        loadTask = Task {
            isRefreshing = forceRefresh
            content = await .from {
                try await getFavoritesUseCase()
            }
            isRefreshing = false
        }
    }
}
