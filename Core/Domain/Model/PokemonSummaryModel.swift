//
//  PokemonSummaryModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモンの一覧表示に必要な最小限のデータを表すドメインモデル。
struct PokemonSummaryModel: Identifiable, Equatable {
    let name: String
    let url: String

    var id: Int {
        url.extractTrailingId()
    }

    var imageUrl: String {
        SpriteURL.sprite(id: id)
    }
}
