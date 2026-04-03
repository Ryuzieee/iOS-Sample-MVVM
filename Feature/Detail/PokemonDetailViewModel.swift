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

    var displayName: String {
        if let species = content.dataOrNil?.species,
           !species.japaneseName.isEmpty
        {
            return species.japaneseName
        }
        return pokemonName.capitalized
    }

    private let getPokemonFullDetailUseCase: GetPokemonFullDetailUseCase
    private let getIsFavoriteUseCase: GetIsFavoriteUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private var loadTask: Task<Void, Never>?

    init(
        pokemonName: String,
        getPokemonFullDetailUseCase: GetPokemonFullDetailUseCase,
        getIsFavoriteUseCase: GetIsFavoriteUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase
    ) {
        self.pokemonName = pokemonName
        self.getPokemonFullDetailUseCase = getPokemonFullDetailUseCase
        self.getIsFavoriteUseCase = getIsFavoriteUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
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
        Task { [weak self] in
            do {
                try await self?.toggleFavoriteUseCase(detail: fullDetail.detail, isFavorite: currentState)
            } catch {
                self?.isFavorite = currentState
                AppLogger.error("Toggle favorite failed: \(error.localizedDescription)", category: AppLogger.ui)
            }
        }
    }

    private func load(forceRefresh: Bool = false) {
        loadTask?.cancel()
        loadTask = Task {
            if !forceRefresh {
                content = .loading
            }
            isRefreshing = forceRefresh

            let state: UiState = await .from {
                try await getPokemonFullDetailUseCase(name: pokemonName, forceRefresh: forceRefresh)
            }
            content = state
            isRefreshing = false
            if case let .success(result) = state {
                loadFavorite(pokemonId: result.detail.id)
            }
        }
    }

    private func loadFavorite(pokemonId: Int) {
        Task { [weak self] in
            guard let self else { return }
            isFavorite = await (try? getIsFavoriteUseCase(id: pokemonId)) ?? false
        }
    }
}
