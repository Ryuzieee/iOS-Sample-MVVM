//
//  SearchView.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// ポケモン検索画面。
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
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

            switch viewModel.content {
            case .idle:
                EmptyContent(message: Strings.Search.searchIdleMessage)
            case .loading:
                LoadingIndicator()
            case let .error(appError):
                ErrorContent(error: appError, onRetry: viewModel.retrySearch)
            case let .success(names):
                List(names, id: \.self) { name in
                    Button(action: { onPokemonTap(name) }) {
                        Text(name.capitalized)
                            .foregroundColor(.primary)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(Strings.List.searchDescription)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(Strings.Common.close) { dismiss() }
            }
        }
    }
}
