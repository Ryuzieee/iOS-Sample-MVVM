//
//  PokemonSpeciesModel.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモン種族情報（図鑑テキスト・分類など）。
struct PokemonSpeciesModel: Equatable, Sendable {
    let japaneseName: String
    let flavorText: String
    let genus: String
    let eggGroups: [String]
    let genderRate: Int
    let captureRate: Int
    let habitat: String?
    let generation: String
    let evolutionChainUrl: String

    /// 性別比率の表示文字列。genderRate が -1 なら「性別なし」。
    var genderText: String {
        if genderRate == -1 {
            return Strings.Detail.labelNoGender
        }
        // PokeAPI の genderRate は 0〜8 の値（1単位 = 12.5%）
        let femalePercent = Double(genderRate) * 12.5
        let malePercent = 100.0 - femalePercent
        return Strings.Detail.genderRatio(femalePercent: femalePercent, malePercent: malePercent)
    }
}
