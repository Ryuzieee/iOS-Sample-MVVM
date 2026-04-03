//
//  PokemonGrid.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// アプリ全体で共有するデザイントークン。
enum DesignTokens {
    static let cardCornerRadius: CGFloat = 12
    static let badgeCornerRadius: CGFloat = 16
    static let searchFieldCornerRadius: CGFloat = 10
    static let cardPadding: CGFloat = 12
    static let gridSpacing: CGFloat = 8
    static let sectionHorizontalPadding: CGFloat = 16
    static let cardShadowOpacity: CGFloat = 0.1
    static let cardShadowRadius: CGFloat = 4
    static let cardShadowY: CGFloat = 2
}

/// PokemonCard をグリッド表示するための共通データ。
struct PokemonGridItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let imageUrl: String
}

/// PokemonCard の2カラムグリッド表示。一覧・お気に入り画面で共通利用。
struct PokemonGrid: View {
    let items: [PokemonGridItem]
    let onPokemonTap: (String) -> Void
    var onItemAppear: ((Int) -> Void)?

    private let columns = [
        GridItem(.flexible(), spacing: DesignTokens.gridSpacing),
        GridItem(.flexible(), spacing: DesignTokens.gridSpacing),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignTokens.gridSpacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                PokemonCard(
                    name: item.name,
                    id: item.id,
                    imageUrl: item.imageUrl,
                    onTap: { onPokemonTap(item.name) }
                )
                .onAppear {
                    onItemAppear?(index)
                }
            }
        }
        .padding(.horizontal, DesignTokens.gridSpacing)
    }
}
