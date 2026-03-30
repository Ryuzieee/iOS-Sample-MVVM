//
//  PokemonGrid.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

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

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items) { item in
                PokemonCard(
                    name: item.name,
                    id: item.id,
                    imageUrl: item.imageUrl,
                    onTap: { onPokemonTap(item.name) }
                )
            }
        }
        .padding(.horizontal, 8)
    }
}
