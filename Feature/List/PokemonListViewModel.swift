//
//  PokemonListViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation

/// ポケモン一覧画面のViewModel。
@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published var content: UiState<[PokemonSummaryModel]> = .idle
    @Published var isLoadingMore = false
    @Published var loadMoreError: AppError?

    var items: [PokemonSummaryModel] {
        content.dataOrNil ?? []
    }

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
        guard case .idle = content else { return }
        load()
    }

    func retry() {
        load()
    }

    func refresh() {
        load(forceRefresh: true)
    }

    func loadMore() {
        guard !isLoadingMore, hasMore else { return }

        isLoadingMore = true
        loadMoreError = nil
        Task {
            do {
                let result = try await getPokemonList(offset: items.count, limit: AppConfig.pageSize)
                if case let .success(current) = content {
                    content = .success(current + result)
                }
                hasMore = result.count == AppConfig.pageSize
            } catch {
                loadMoreError = error.toAppError()
                AppLogger.error("Load more failed: \(error.localizedDescription)", category: AppLogger.ui)
            }
            isLoadingMore = false
        }
    }

    private func load(forceRefresh: Bool = false) {
        loadTask?.cancel()
        loadTask = Task {
            if !forceRefresh {
                content = .loading
            }
            let state: UiState = await .from {
                try await self.getPokemonList(offset: 0, limit: AppConfig.pageSize)
            }
            content = state
            if case let .success(result) = state {
                hasMore = result.count == AppConfig.pageSize
            }
        }
    }
}
