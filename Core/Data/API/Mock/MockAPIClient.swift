//
//  MockAPIClient.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import Foundation

private let mockDelay: Duration = .milliseconds(300)
private let artworkBaseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork"

/// デバッグ用のモック API クライアント。MockScenarioHolder のシナリオに応じてレスポンスを返す。
/// Android 版 MockData / MockInterceptor 相当。実際のポケモンデータを返す。
final class MockAPIClient: PokeAPIClientProtocol {
    private let scenarioHolder: MockScenarioHolder

    init(scenarioHolder: MockScenarioHolder = .shared) {
        self.scenarioHolder = scenarioHolder
    }

    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        try await simulateScenario()
        let pokemons = MockPokemons.all
        let sliced = pokemons.dropFirst(offset).prefix(limit)
        return PokemonListResponse(results: sliced.map { pokemon in
            .init(name: pokemon.name, url: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)/")
        })
    }

    func getPokemonDetail(name: String) async throws -> PokemonDetailResponse {
        try await simulateScenario()
        guard let pokemon = MockPokemons.byName[name] else {
            return buildDetailResponse(MockPokemons.all[0], overrideName: name)
        }
        return buildDetailResponse(pokemon)
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesResponse {
        try await simulateScenario()
        let pokemon = MockPokemons.byName[name] ?? MockPokemons.all[0]
        return PokemonSpeciesResponse(
            names: [.init(name: pokemon.jaName, language: NamedResource(name: "ja"))],
            flavorTextEntries: [.init(
                flavorText: pokemon.flavorText,
                language: NamedResource(name: "ja"),
                version: NamedResource(name: "red")
            )],
            evolutionChain: .init(
                url: "https://pokeapi.co/api/v2/evolution-chain/\(pokemon.evolutionChainId)/"
            ),
            genera: [.init(genus: pokemon.genus, language: NamedResource(name: "ja"))],
            eggGroups: pokemon.eggGroups.map { NamedResource(name: $0) },
            genderRate: pokemon.genderRate,
            captureRate: pokemon.captureRate,
            habitat: pokemon.habitat.map { NamedResource(name: $0) },
            generation: NamedResource(name: pokemon.generation)
        )
    }

    func getEvolutionChain(url: String) async throws -> EvolutionChainResponse {
        try await simulateScenario()
        let chainId = extractChainId(from: url)
        if let chain = MockPokemons.evolutionChains[chainId] {
            return chain
        }
        return MockPokemons.evolutionChains[1] ?? EvolutionChainResponse(
            id: chainId,
            chain: .init(species: .init(name: "unknown", url: ""), evolvesTo: [], evolutionDetails: [])
        )
    }

    func getAbility(name: String) async throws -> AbilityResponse {
        try await simulateScenario()
        let jaName = MockPokemons.abilityJaNames[name] ?? name
        return AbilityResponse(names: [
            .init(name: jaName, language: NamedResource(name: "ja")),
        ])
    }

    private func simulateScenario() async throws {
        try await Task.sleep(for: mockDelay)

        switch scenarioHolder.current {
        case .success:
            return
        case .networkError:
            throw URLError(.notConnectedToInternet)
        case let .customError(code, _, storeUrl):
            throw HTTPResponseError(statusCode: code, storeUrl: storeUrl)
        }
    }

    private func buildDetailResponse(_ pokemon: MockPokemon, overrideName: String? = nil) -> PokemonDetailResponse {
        var abilitySlots = pokemon.abilities.map {
            PokemonDetailResponse.AbilitySlot(ability: .init(name: $0), isHidden: false)
        }
        if let hidden = pokemon.hiddenAbility {
            abilitySlots.append(.init(ability: .init(name: hidden), isHidden: true))
        }

        return PokemonDetailResponse(
            id: pokemon.id,
            name: overrideName ?? pokemon.name,
            height: pokemon.height,
            weight: pokemon.weight,
            baseExperience: pokemon.baseExperience,
            types: pokemon.types.map { .init(type: .init(name: $0)) },
            abilities: abilitySlots,
            sprites: .init(other: .init(officialArtwork: .init(
                frontDefault: "\(artworkBaseUrl)/\(pokemon.id).png"
            ))),
            stats: [
                .init(baseStat: pokemon.hp, stat: .init(name: "hp")),
                .init(baseStat: pokemon.attack, stat: .init(name: "attack")),
                .init(baseStat: pokemon.defense, stat: .init(name: "defense")),
                .init(baseStat: pokemon.spAttack, stat: .init(name: "special-attack")),
                .init(baseStat: pokemon.spDefense, stat: .init(name: "special-defense")),
                .init(baseStat: pokemon.speed, stat: .init(name: "speed")),
            ]
        )
    }

    private func extractChainId(from url: String) -> Int {
        url.extractTrailingId(fallback: 1)
    }
}
