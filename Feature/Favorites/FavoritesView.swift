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
        UiStateContent(
            state: viewModel.content,
            onRetry: viewModel.retry
        ) { favorites in
            if favorites.isEmpty {
                EmptyContent(
                    message: Strings.Favorites.emptyMessage,
                    subMessage: Strings.Favorites.emptySubMessage
                )
            } else {
                ScrollView {
                    PokemonGrid(
                        items: viewModel.gridItems,
                        onPokemonTap: onPokemonTap
                    )
                }
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
