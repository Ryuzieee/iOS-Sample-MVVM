//
//  FavoritesView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// お気に入り一覧画面。
struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    let onPokemonTap: (String) -> Void

    var body: some View {
        Group {
            switch viewModel.content {
            case .loading:
                LoadingIndicator()
            case .error(let message, let type):
                ErrorContent(message: message, onRetry: viewModel.retry, errorType: type)
            case .success(let favorites):
                if favorites.isEmpty {
                    EmptyContent(
                        message: "お気に入りはまだありません",
                        subMessage: "詳細画面の♡ボタンで追加できます"
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
        .navigationTitle("おきにいり")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            viewModel.refresh()
        }
    }
}
