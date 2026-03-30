//
//  PokemonDetailMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// PokemonDetailResponse → PokemonDetailModel への変換。
extension PokemonDetailModel {
    init(from response: PokemonDetailResponse) {
        self.init(
            id: response.id,
            name: response.name,
            height: response.height,
            weight: response.weight,
            baseExperience: response.baseExperience,
            types: response.types.map(\.type.name),
            abilities: response.abilities.map {
                Ability(
                    name: $0.ability.name,
                    isHidden: $0.isHidden
                )
            },
            imageUrl: response.sprites.other.officialArtwork.frontDefault,
            stats: response.stats.map {
                Stat(name: $0.stat.name, value: $0.baseStat)
            }
        )
    }
}
