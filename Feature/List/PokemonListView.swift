//
//  PokemonListView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// ポケモン一覧画面。
struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    let onPokemonTap: (String) -> Void
    let onSearchTap: () -> Void
    let onFavoritesTap: () -> Void

    var body: some View {
        UiStateContent(
            state: viewModel.content,
            onRetry: viewModel.retry
        ) { _ in
            ScrollView {
                PokemonGrid(
                    items: viewModel.gridItems,
                    onPokemonTap: onPokemonTap,
                    onItemAppear: viewModel.onItemAppear
                )

                if viewModel.isLoadingMore {
                    ProgressView()
                        .padding()
                }
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
        .alert(
            Strings.Common.errorTitle,
            isPresented: loadMoreErrorBinding
        ) {
            Button(Strings.Common.retry) { viewModel.loadMore() }
            Button(Strings.Common.close, role: .cancel) {}
        } message: {
            Text(viewModel.loadMoreError?.errorDescription ?? Strings.Common.errorTitle)
        }
    }

    private var loadMoreErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.loadMoreError != nil },
            set: { if !$0 { viewModel.loadMoreError = nil } }
        )
    }
}
