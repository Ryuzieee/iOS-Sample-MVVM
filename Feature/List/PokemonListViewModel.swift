//
//  PokemonListViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation

private let pageSize = 20

/// ポケモン一覧画面のViewModel。
final class PokemonListViewModel: ObservableObject {
    @Published var items: [PokemonSummaryModel] = []
    @Published var loadState: UiState<Bool> = .idle
    @Published var isLoadingMore = false
    @Published var isRefreshing = false

    private let getPokemonList: GetPokemonListUseCase
    private var hasMore = true

    init(getPokemonList: GetPokemonListUseCase) {
        self.getPokemonList = getPokemonList
        loadInitial()
    }

    func refresh() {
        isRefreshing = true
        Task { @MainActor in
            do {
                let result = try await getPokemonList.execute(offset: 0, limit: pageSize)
                items = result
                loadState = .success(true)
                hasMore = result.count >= pageSize
            } catch {
                // リフレッシュ失敗時は既存データを維持
            }
            isRefreshing = false
        }
    }

    func loadMore() {
        guard !isLoadingMore, hasMore else { return }

        isLoadingMore = true
        Task { @MainActor in
            do {
                let result = try await getPokemonList.execute(offset: items.count, limit: pageSize)
                items += result
                hasMore = result.count >= pageSize
            } catch {
                // 追加読み込み失敗時はスキップ
            }
            isLoadingMore = false
        }
    }

    private func loadInitial() {
        loadState = .loading
        Task { @MainActor in
            let state = await loadAsUiState {
                try await getPokemonList.execute(offset: 0, limit: pageSize)
            }
            if case let .success(result) = state {
                items = result
                hasMore = result.count >= pageSize
                loadState = .success(true)
            } else if case let .error(message, type) = state {
                loadState = .error(message: message, type: type)
            }
        }
    }
}
