//
//  PokemonSpeciesMapperTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import XCTest
@testable import iOS_Sample_MVVM

final class PokemonSpeciesMapperTests: XCTestCase {
    func test_日本語の名前とフレーバーテキストと分類を正しく抽出する() {
        let response = PokemonSpeciesResponse(
            names: [
                PokemonSpeciesResponse.Name(name: "Bulbasaur", language: NamedResource(name: "en")),
                PokemonSpeciesResponse.Name(name: "フシギダネ", language: NamedResource(name: "ja")),
            ],
            flavorTextEntries: [
                PokemonSpeciesResponse.FlavorTextEntry(
                    flavorText: "A strange seed.",
                    language: NamedResource(name: "en"),
                    version: NamedResource(name: "red")
                ),
                PokemonSpeciesResponse.FlavorTextEntry(
                    flavorText: "たいようの ひかりを\nあびるほど からだに\u{000c}ちからが わいてくる。",
                    language: NamedResource(name: "ja"),
                    version: NamedResource(name: "red")
                ),
            ],
            evolutionChain: PokemonSpeciesResponse
                .EvolutionChainRef(url: "https://pokeapi.co/api/v2/evolution-chain/1/"),
            genera: [
                PokemonSpeciesResponse.Genus(genus: "Seed Pokémon", language: NamedResource(name: "en")),
                PokemonSpeciesResponse.Genus(genus: "たねポケモン", language: NamedResource(name: "ja")),
            ],
            eggGroups: [NamedResource(name: "monster"), NamedResource(name: "plant")],
            genderRate: 1,
            captureRate: 45,
            habitat: NamedResource(name: "grassland"),
            generation: NamedResource(name: "generation-i")
        )

        let model = PokemonSpeciesModel(from: response)

        XCTAssertEqual(model.japaneseName, "フシギダネ")
        XCTAssertEqual(model.flavorText, "たいようの ひかりを あびるほど からだに ちからが わいてくる。")
        XCTAssertEqual(model.genus, "たねポケモン")
        XCTAssertEqual(model.eggGroups, ["monster", "plant"])
        XCTAssertEqual(model.genderRate, 1)
        XCTAssertEqual(model.captureRate, 45)
        XCTAssertEqual(model.habitat, "grassland")
        XCTAssertEqual(model.generation, "generation-i")
    }

    func test_日本語がない場合に英語にフォールバックする() {
        let response = PokemonSpeciesResponse(
            names: [
                PokemonSpeciesResponse.Name(name: "Bulbasaur", language: NamedResource(name: "en")),
            ],
            flavorTextEntries: [
                PokemonSpeciesResponse.FlavorTextEntry(
                    flavorText: "A strange seed.",
                    language: NamedResource(name: "en"),
                    version: NamedResource(name: "red")
                ),
            ],
            evolutionChain: PokemonSpeciesResponse.EvolutionChainRef(url: "url"),
            genera: [
                PokemonSpeciesResponse.Genus(genus: "Seed Pokémon", language: NamedResource(name: "en")),
            ],
            eggGroups: [],
            genderRate: -1,
            captureRate: 45,
            habitat: nil,
            generation: NamedResource(name: "generation-i")
        )

        let model = PokemonSpeciesModel(from: response)

        XCTAssertEqual(model.flavorText, "A strange seed.")
        XCTAssertEqual(model.genus, "Seed Pokémon")
        XCTAssertNil(model.habitat)
    }
}
