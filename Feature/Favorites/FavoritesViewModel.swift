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

    private let getFavorites: GetFavoritesUseCase

    init(getFavorites: GetFavoritesUseCase) {
        self.getFavorites = getFavorites
        load()
    }

    func retry() {
        load()
    }

    func refresh() {
        load(forceRefresh: true)
    }

    private func load(forceRefresh: Bool = false) {
        Task {
            isRefreshing = forceRefresh
            content = await loadAsUiState {
                try await getFavorites()
            }
            isRefreshing = false
        }
    }
}
