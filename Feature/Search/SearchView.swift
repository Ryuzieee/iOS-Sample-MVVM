//
//  SearchView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// ポケモン検索画面。
struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    let onPokemonTap: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            SearchTextField(
                text: $viewModel.query,
                placeholder: Strings.Search.searchPlaceholder
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            UiStateContent(
                state: viewModel.content,
                onRetry: viewModel.retrySearch,
                successContent: { names in
                    List(names, id: \.self) { name in
                        Button(action: { onPokemonTap(name) }) {
                            Text(name.capitalized)
                                .foregroundColor(.primary)
                        }
                    }
                    .listStyle(.plain)
                },
                idleContent: {
                    EmptyContent(message: Strings.Search.searchIdleMessage)
                }
            )
        }
        .navigationTitle(Strings.List.searchDescription)
        .navigationBarTitleDisplayMode(.inline)
        .dismissToolbar()
    }
}
