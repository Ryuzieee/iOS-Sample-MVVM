//
//  PokemonDetailMapper.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// PokemonDetailResponse → PokemonDetailModel への変換。
enum PokemonDetailMapper {
    static func toModel(from response: PokemonDetailResponse) -> PokemonDetailModel {
        PokemonDetailModel(
            id: response.id,
            name: response.name,
            height: response.height,
            weight: response.weight,
            baseExperience: response.baseExperience,
            types: response.types.map(\.type.name),
            abilities: response.abilities.map {
                PokemonDetailModel.Ability(
                    name: $0.ability.name,
                    isHidden: $0.isHidden
                )
            },
            imageUrl: response.sprites.other.officialArtwork.frontDefault,
            stats: response.stats.map {
                PokemonDetailModel.Stat(name: $0.stat.name, value: $0.baseStat)
            }
        )
    }
}
