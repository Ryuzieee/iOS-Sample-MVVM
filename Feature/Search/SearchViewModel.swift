//
//  SearchViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation

/// 検索画面のViewModel。クエリ入力にデバウンスを適用する。
@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var content: UiState<[String]> = .idle

    private let searchPokemonUseCase: SearchPokemonUseCase
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(searchPokemonUseCase: SearchPokemonUseCase) {
        self.searchPokemonUseCase = searchPokemonUseCase

        $query
            .debounce(for: .milliseconds(AppConfig.searchDebounceMs), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
    }

    deinit {
        searchTask?.cancel()
    }

    func retrySearch() {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        search(query: query)
    }

    private func search(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            content = .idle
            return
        }

        content = .loading
        searchTask?.cancel()
        searchTask = Task {
            content = await .from {
                try await searchPokemonUseCase(query: trimmed)
            }
        }
    }
}
