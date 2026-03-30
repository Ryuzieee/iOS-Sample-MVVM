//
//  PokemonDetailModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン詳細画面で表示するデータを表すドメインモデル。
struct PokemonDetailModel: Identifiable, Equatable, Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int
    let types: [String]
    let abilities: [Ability]
    let imageUrl: String
    let stats: [Stat]

    /// ポケモンの各種基本ステータス（HP・攻撃力など）。
    struct Stat: Equatable, Codable {
        let name: String
        let value: Int
    }

    /// ポケモンの特性。
    struct Ability: Equatable, Codable {
        let name: String
        var japaneseName = ""
        let isHidden: Bool
    }
}
