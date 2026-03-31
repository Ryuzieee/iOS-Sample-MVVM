//
//  PokemonListView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// 次ページ読み込みを開始する残りアイテム数の閾値。
private let paginationThreshold = 4

/// ポケモン一覧画面。
struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    let onPokemonTap: (String) -> Void
    let onSearchTap: () -> Void
    let onFavoritesTap: () -> Void

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .loading:
                LoadingIndicator()
            case let .error(appError):
                ErrorContent(error: appError, onRetry: viewModel.refresh)
            case .success, .idle:
                pokemonList
            }
        }
        .navigationTitle(Strings.List.screenTitle)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AppIconButton(
                    systemName: "magnifyingglass",
                    accessibilityLabel: Strings.List.searchDescription,
                    action: onSearchTap
                )
                AppIconButton(
                    systemName: "heart.fill",
                    accessibilityLabel: Strings.List.favoritesDescription,
                    action: onFavoritesTap
                )
            }
        }
        .task {
            viewModel.loadInitial()
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    private var pokemonList: some View {
        ScrollView {
            PokemonGrid(
                items: viewModel.gridItems,
                onPokemonTap: onPokemonTap,
                onItemAppear: { index in
                    if index >= viewModel.items.count - paginationThreshold {
                        viewModel.loadMore()
                    }
                }
            )

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding()
            }
        }
    }
}
