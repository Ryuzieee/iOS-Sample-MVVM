//
//  PokemonCard.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import SwiftUI

/// ポケモン一覧のカードUI。画像・名前・IDを表示する。
struct PokemonCard: View {
    let name: String
    let id: Int
    let imageUrl: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                PokemonImage(
                    imageUrl: imageUrl,
                    size: 80
                )
                Text(name.capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Text("\(Strings.Common.idPrefix)\(id)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(DesignTokens.cardPadding)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .shadow(
                color: .black.opacity(DesignTokens.cardShadowOpacity),
                radius: DesignTokens.cardShadowRadius,
                y: DesignTokens.cardShadowY
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PokemonCard(
        name: "bulbasaur",
        id: 1,
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
        onTap: {}
    )
    .frame(width: 180)
    .padding()
}
