//
//  SearchViewModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Combine
import Foundation
import SwiftUI

private let debounceMs = 500

/// 検索画面のViewModel。クエリ入力に 500ms のデバウンスを適用する。
@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var content: UiState<[String]> = .idle

    private let searchPokemon: SearchPokemonUseCase
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(searchPokemon: SearchPokemonUseCase) {
        self.searchPokemon = searchPokemon

        $query
            .debounce(for: .milliseconds(debounceMs), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
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
                try await searchPokemon(query: trimmed)
            }
        }
    }
}
