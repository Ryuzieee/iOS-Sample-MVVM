//
//  PokemonTextComponents.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import SwiftUI

/// ポケモンの図鑑番号を `#id` 形式で表示するテキスト。
struct PokemonIdText: View {
    let id: Int

    var body: some View {
        Text("\(Strings.Common.idPrefix)\(id)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

/// ポケモンの名前を先頭大文字で表示するテキスト。
struct PokemonNameText: View {
    let name: String
    var font: Font = .body

    var body: some View {
        Text(name.capitalized)
            .font(font)
    }
}
