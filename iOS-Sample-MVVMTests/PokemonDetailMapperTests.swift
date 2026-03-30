//
//  PokemonDetailMapperTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class PokemonDetailMapperTests: XCTestCase {
    func test_DTOのフィールドをModelに正しく変換する() {
        let response = PokemonDetailResponse(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: [
                PokemonDetailResponse.TypeSlot(type: PokemonDetailResponse.TypeInfo(name: "grass")),
                PokemonDetailResponse.TypeSlot(type: PokemonDetailResponse.TypeInfo(name: "poison")),
            ],
            abilities: [
                PokemonDetailResponse.AbilitySlot(
                    ability: PokemonDetailResponse.AbilityInfo(name: "overgrow"),
                    isHidden: false
                ),
                PokemonDetailResponse.AbilitySlot(
                    ability: PokemonDetailResponse.AbilityInfo(name: "chlorophyll"),
                    isHidden: true
                ),
            ],
            sprites: PokemonDetailResponse.Sprites(
                other: PokemonDetailResponse.Sprites.Other(
                    officialArtwork: PokemonDetailResponse.Sprites.Other.OfficialArtwork(
                        frontDefault: "https://example.com/1.png"
                    )
                )
            ),
            stats: [
                PokemonDetailResponse.StatSlot(baseStat: 45, stat: PokemonDetailResponse.StatInfo(name: "hp")),
                PokemonDetailResponse.StatSlot(baseStat: 49, stat: PokemonDetailResponse.StatInfo(name: "attack")),
            ]
        )

        let model = PokemonDetailMapper.toModel(from: response)

        XCTAssertEqual(model.id, 1)
        XCTAssertEqual(model.name, "bulbasaur")
        XCTAssertEqual(model.height, 7)
        XCTAssertEqual(model.weight, 69)
        XCTAssertEqual(model.baseExperience, 64)
        XCTAssertEqual(model.types, ["grass", "poison"])
        XCTAssertEqual(model.imageUrl, "https://example.com/1.png")
        XCTAssertEqual(model.abilities.count, 2)
        XCTAssertEqual(model.abilities[0].name, "overgrow")
        XCTAssertFalse(model.abilities[0].isHidden)
        XCTAssertEqual(model.abilities[1].name, "chlorophyll")
        XCTAssertTrue(model.abilities[1].isHidden)
        XCTAssertEqual(model.stats.count, 2)
        XCTAssertEqual(model.stats[0].name, "hp")
        XCTAssertEqual(model.stats[0].value, 45)
    }
}
