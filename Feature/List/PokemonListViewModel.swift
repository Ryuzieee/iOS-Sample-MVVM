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
@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published var items: [PokemonSummaryModel] = []
    @Published var loadState: UiState<Bool> = .idle
    @Published var isLoadingMore = false
    @Published var isRefreshing = false

    private let getPokemonList: GetPokemonListUseCase
    private var hasMore = true
    private var loadTask: Task<Void, Never>?

    init(getPokemonList: GetPokemonListUseCase) {
        self.getPokemonList = getPokemonList
    }

    func loadInitial() {
        guard case .idle = loadState else { return }
        loadInitialData()
    }

    func refresh() {
        isRefreshing = true
        Task {
            do {
                let result = try await getPokemonList(offset: 0, limit: pageSize)
                items = result
                loadState = .success(true)
                hasMore = result.count == pageSize
            } catch {
                AppLogger.error("Refresh failed: \(error.localizedDescription)", category: AppLogger.ui)
            }
            isRefreshing = false
        }
    }

    func loadMore() {
        guard !isLoadingMore, hasMore else { return }

        isLoadingMore = true
        Task {
            do {
                let result = try await getPokemonList(offset: items.count, limit: pageSize)
                items += result
                hasMore = result.count == pageSize
            } catch {
                AppLogger.error("Load more failed: \(error.localizedDescription)", category: AppLogger.ui)
            }
            isLoadingMore = false
        }
    }

    private func loadInitialData() {
        loadState = .loading
        loadTask = Task {
            let state: UiState = await .from {
                try await getPokemonList(offset: 0, limit: pageSize)
            }
            if case let .success(result) = state {
                items = result
                hasMore = result.count == pageSize
                loadState = .success(true)
            } else if case let .error(message, type) = state {
                loadState = .error(message: message, type: type)
            }
        }
    }
}
