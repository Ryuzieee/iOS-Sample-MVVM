//
//  FavoritesViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation
import Combine

/// お気に入り一覧画面のViewModel。
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
        Task { @MainActor in
            isRefreshing = forceRefresh
            do {
                let result = try await getFavorites.execute()
                content = .success(result)
            } catch {
                content = .error(message: error.localizedDescription, type: .general)
            }
            isRefreshing = false
        }
    }
}
