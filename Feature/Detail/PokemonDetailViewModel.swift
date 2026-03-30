//
//  PokemonDetailViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation

/// ポケモン詳細画面のViewModel。
final class PokemonDetailViewModel: ObservableObject {
    @Published var content: UiState<PokemonFullDetailModel> = .loading
    @Published var isFavorite = false
    @Published var isRefreshing = false

    let pokemonName: String

    private let getPokemonFullDetail: GetPokemonFullDetailUseCase
    private let getIsFavorite: GetIsFavoriteUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase

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
        Task { @MainActor in
            try? await toggleFavoriteUseCase.execute(detail: fullDetail.detail, isFavorite: isFavorite)
            isFavorite.toggle()
        }
    }

    private func load(forceRefresh: Bool = false) {
        Task { @MainActor in
            content = .loading
            isRefreshing = forceRefresh

            let state = await loadAsUiState {
                try await getPokemonFullDetail.execute(name: pokemonName, forceRefresh: forceRefresh)
            }
            content = state
            isRefreshing = false
            if case let .success(result) = state {
                loadFavorite(pokemonId: result.detail.id)
            }
        }
    }

    private func loadFavorite(pokemonId: Int) {
        Task { @MainActor in
            isFavorite = (try? await getIsFavorite.execute(id: pokemonId)) ?? false
        }
    }
}
