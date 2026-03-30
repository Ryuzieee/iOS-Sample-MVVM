//
//  FavoritesView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// お気に入り一覧画面。
struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FavoritesViewModel
    let onPokemonTap: (String) -> Void

    var body: some View {
        Group {
            switch viewModel.content {
            case .loading:
                LoadingIndicator()
            case let .error(message, type):
                ErrorContent(message: message, onRetry: viewModel.retry, errorType: type)
            case let .success(favorites):
                if favorites.isEmpty {
                    EmptyContent(
                        message: Strings.Favorites.emptyMessage,
                        subMessage: Strings.Favorites.emptySubMessage
                    )
                } else {
                    ScrollView {
                        PokemonGrid(
                            items: favorites.map {
                                PokemonGridItem(id: $0.id, name: $0.name, imageUrl: $0.imageUrl)
                            },
                            onPokemonTap: onPokemonTap
                        )
                    }
                }
            case .idle:
                EmptyView()
            }
        }
        .navigationTitle(Strings.Favorites.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(Strings.Common.close) { dismiss() }
            }
        }
        .task {
            viewModel.loadIfNeeded()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}
