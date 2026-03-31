//
//  PokemonDetailViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation

/// ポケモン詳細画面のViewModel。
@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var content: UiState<PokemonFullDetailModel> = .loading
    @Published var isFavorite = false
    @Published var isRefreshing = false

    let pokemonName: String

    private let getPokemonFullDetail: GetPokemonFullDetailUseCase
    private let getIsFavorite: GetIsFavoriteUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private var loadTask: Task<Void, Never>?

    init(
        pokemonName: String,
        getPokemonFullDetail: GetPokemonFullDetailUseCase,
        getIsFavorite: GetIsFavoriteUseCase,
        toggleFavorite: ToggleFavoriteUseCase
    ) {
        self.pokemonName = pokemonName
        self.getPokemonFullDetail = getPokemonFullDetail
        self.getIsFavorite = getIsFavorite
        toggleFavoriteUseCase = toggleFavorite
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

    func toggleFavorite() {
        guard let fullDetail = content.dataOrNil else { return }
        let currentState = isFavorite
        isFavorite.toggle()
        Task {
            do {
                try await toggleFavoriteUseCase(detail: fullDetail.detail, isFavorite: currentState)
            } catch {
                isFavorite = currentState
                AppLogger.error("Toggle favorite failed: \(error.localizedDescription)", category: AppLogger.ui)
            }
        }
    }

    private func load(forceRefresh: Bool = false) {
        loadTask?.cancel()
        loadTask = Task {
            content = .loading
            isRefreshing = forceRefresh

            let state: UiState = await .from {
                try await getPokemonFullDetail(name: pokemonName, forceRefresh: forceRefresh)
            }
            content = state
            isRefreshing = false
            if case let .success(result) = state {
                loadFavorite(pokemonId: result.detail.id)
            }
        }
    }

    private func loadFavorite(pokemonId: Int) {
        Task {
            isFavorite = await (try? getIsFavorite(id: pokemonId)) ?? false
        }
    }
}
