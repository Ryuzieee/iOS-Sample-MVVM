//
//  PokemonSummaryModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

private let spriteURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"

/// ポケモンの一覧表示に必要な最小限のデータを表すドメインモデル。
struct PokemonSummaryModel: Identifiable, Equatable {
    let name: String
    let url: String

    var id: Int {
        guard let last = url
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .split(separator: "/")
            .last,
            let value = Int(last)
        else {
            return 0
        }
        return value
    }

    var imageUrl: String {
        "\(spriteURL)\(id).png"
    }
}
