//
//  MockAPIClient.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

private let mockDelayNanoseconds: UInt64 = 300_000_000

/// デバッグ用のモック API クライアント。MockScenarioHolder のシナリオに応じてレスポンスを返す。
final class MockAPIClient: PokeAPIClientProtocol {
    private let scenarioHolder: MockScenarioHolder

    init(scenarioHolder: MockScenarioHolder = .shared) {
        self.scenarioHolder = scenarioHolder
    }

    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        try await simulateScenario()
        return PokemonListResponse(results: (1...min(limit, 20)).map { i in
            let index = offset + i
            return .init(name: "pokemon-\(index)", url: "https://pokeapi.co/api/v2/pokemon/\(index)/")
        })
    }

    func getPokemonDetail(name: String) async throws -> PokemonDetailResponse {
        try await simulateScenario()
        return PokemonDetailResponse(
            id: 1,
            name: name,
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: [.init(type: .init(name: "grass"))],
            abilities: [.init(ability: .init(name: "overgrow"), isHidden: false)],
            sprites: .init(other: .init(officialArtwork: .init(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"))),
            stats: [
                .init(baseStat: 45, stat: .init(name: "hp")),
                .init(baseStat: 49, stat: .init(name: "attack")),
                .init(baseStat: 49, stat: .init(name: "defense")),
            ]
        )
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesResponse {
        try await simulateScenario()
        return PokemonSpeciesResponse(
            names: [.init(name: "モックポケモン", language: NamedResource(name: "ja"))],
            flavorTextEntries: [.init(flavorText: "モックの説明文です。", language: NamedResource(name: "ja"), version: NamedResource(name: "red"))],
            evolutionChain: .init(url: "https://pokeapi.co/api/v2/evolution-chain/1/"),
            genera: [.init(genus: "モックポケモン", language: NamedResource(name: "ja"))],
            eggGroups: [NamedResource(name: "monster")],
            genderRate: 1,
            captureRate: 45,
            habitat: nil,
            generation: NamedResource(name: "generation-i")
        )
    }

    func getEvolutionChain(url: String) async throws -> EvolutionChainResponse {
        try await simulateScenario()
        return EvolutionChainResponse(
            id: 1,
            chain: .init(
                species: .init(name: "mock-base", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
                evolvesTo: [],
                evolutionDetails: []
            )
        )
    }

    func getAbility(name: String) async throws -> AbilityResponse {
        try await simulateScenario()
        return AbilityResponse(names: [
            .init(name: "モック特性", language: NamedResource(name: "ja")),
        ])
    }

    // MARK: - Private

    private func simulateScenario() async throws {
        try await Task.sleep(nanoseconds: mockDelayNanoseconds)

        switch scenarioHolder.current {
        case .success:
            return
        case .networkError:
            throw URLError(.notConnectedToInternet)
        case .customError(let code, _, let storeUrl):
            throw HTTPResponseError(statusCode: code, storeUrl: storeUrl)
        }
    }
}
