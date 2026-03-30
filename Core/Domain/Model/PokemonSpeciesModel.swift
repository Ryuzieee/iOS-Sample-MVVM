//
//  PokemonSpeciesModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン種族情報（図鑑テキスト・分類など）。
struct PokemonSpeciesModel: Equatable {
    let japaneseName: String
    let flavorText: String
    let genus: String
    let eggGroups: [String]
    let genderRate: Int
    let captureRate: Int
    let habitat: String?
    let generation: String
    let evolutionChainUrl: String
}
