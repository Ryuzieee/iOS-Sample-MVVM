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
                Text("#\(id)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }
}
