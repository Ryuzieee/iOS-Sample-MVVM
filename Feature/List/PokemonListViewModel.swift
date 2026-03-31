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
    @Published var refreshError: AppError?
    @Published var loadMoreError: AppError?

    var gridItems: [PokemonGridItem] {
        items.map { PokemonGridItem(id: $0.id, name: $0.name, imageUrl: $0.imageUrl) }
    }

    private let getPokemonList: GetPokemonListUseCase
    private var hasMore = true
    private var loadTask: Task<Void, Never>?

    init(getPokemonList: GetPokemonListUseCase) {
        self.getPokemonList = getPokemonList
    }

    deinit {
        loadTask?.cancel()
    }

    func loadInitial() {
        guard case .idle = loadState else { return }
        loadInitialData()
    }

    func refresh() {
        isRefreshing = true
        refreshError = nil
        Task {
            do {
                let result = try await getPokemonList(offset: 0, limit: pageSize)
                items = result
                loadState = .loaded
                hasMore = result.count == pageSize
            } catch {
                refreshError = error.toAppError()
                AppLogger.error("Refresh failed: \(error.localizedDescription)", category: AppLogger.ui)
            }
            isRefreshing = false
        }
    }

    func loadMore() {
        guard !isLoadingMore, hasMore else { return }

        isLoadingMore = true
        loadMoreError = nil
        Task {
            do {
                let result = try await getPokemonList(offset: items.count, limit: pageSize)
                items += result
                hasMore = result.count == pageSize
            } catch {
                loadMoreError = error.toAppError()
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
                loadState = .loaded
            } else if case let .error(appError) = state {
                loadState = .error(appError)
            }
        }
    }
}
