//
//  PokemonSpeciesMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// PokemonSpeciesResponse → PokemonSpeciesModel への変換。
extension PokemonSpeciesModel {
    init(from response: PokemonSpeciesResponse) {
        let nameMap = Dictionary(
            response.names.map { ($0.language.name, $0.name) },
            uniquingKeysWith: { first, _ in first }
        )
        let jaName = AppConfig.languagePriority.compactMap { nameMap[$0] }.first ?? ""

        let jaFlavorText = response.flavorTextEntries
            .last { $0.language.name == "ja" }?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000c}", with: " ")
            ?? response.flavorTextEntries.last { $0.language.name == "en" }?.flavorText
            ?? ""

        let jaGenus = response.genera
            .first { $0.language.name == "ja" }?
            .genus
            ?? response.genera.first { $0.language.name == "en" }?.genus
            ?? ""

        self.init(
            japaneseName: jaName,
            flavorText: jaFlavorText,
            genus: jaGenus,
            eggGroups: response.eggGroups.map(\.name),
            genderRate: response.genderRate,
            captureRate: response.captureRate,
            habitat: response.habitat?.name,
            generation: response.generation.name,
            evolutionChainUrl: response.evolutionChain.url
        )
    }
}
