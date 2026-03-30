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
        Group {
            switch viewModel.loadState {
            case .loading:
                LoadingIndicator()
            case .error(let message, let type):
                ErrorContent(message: message, onRetry: viewModel.refresh, errorType: type)
            case .success, .idle:
                pokemonList
            }
        }
        .navigationTitle("ポケモン図鑑")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: onSearchTap) {
                    Image(systemName: "magnifyingglass")
                }
                Button(action: onFavoritesTap) {
                    Image(systemName: "heart.fill")
                }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    private var pokemonList: some View {
        ScrollView {
            PokemonGrid(
                items: viewModel.items.map {
                    PokemonGridItem(id: $0.id, name: $0.name, imageUrl: $0.imageUrl)
                },
                onPokemonTap: onPokemonTap
            )

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding()
            }

            // 無限スクロールトリガー
            Color.clear
                .frame(height: 1)
                .onAppear {
                    viewModel.loadMore()
                }
        }
    }
}
