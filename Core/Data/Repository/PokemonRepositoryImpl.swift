//
//  PokemonRepositoryImpl.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

private let pokemonListLimit = 2000

/// PokemonRepositoryProtocol の実装クラス。
final class PokemonRepositoryImpl: PokemonRepositoryProtocol {
    private let apiClient: PokeAPIClientProtocol
    private let cacheStore: PokemonCacheStore

    init(apiClient: PokeAPIClientProtocol, cacheStore: PokemonCacheStore = .shared) {
        self.apiClient = apiClient
        self.cacheStore = cacheStore
    }

    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonSummaryModel] {
        try await handleRemote(
            fetch: { try await apiClient.getPokemonList(limit: limit, offset: offset) },
            toModel: { response in
                response.results.map { PokemonSummaryModel(name: $0.name, url: $0.url) }
            }
        )
    }

    func getPokemonDetail(name: String, forceRefresh: Bool) async throws -> PokemonDetailModel {
        try await handleWithCache(
            forceRefresh: forceRefresh,
            cache: CacheStrategy(
                load: { self.cacheStore.getPokemonDetail(name: name)?.data },
                cachedAt: { _ in self.cacheStore.getPokemonDetail(name: name)?.cachedAt },
                save: { detail in self.cacheStore.savePokemonDetail(detail, name: name) }
            ),
            fetch: { try await self.apiClient.getPokemonDetail(name: name) },
            toEntity: { PokemonDetailModel(from: $0) },
            toModel: { $0 }
        )
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesModel {
        try await handleRemote(
            fetch: { try await apiClient.getPokemonSpecies(name: name) },
            toModel: { PokemonSpeciesModel(from: $0) }
        )
    }

    func getEvolutionChain(url: String) async throws -> [EvolutionStageModel] {
        try await handleRemote(
            fetch: { try await apiClient.getEvolutionChain(url: url) },
            toModel: { [EvolutionStageModel](from: $0) }
        )
    }

    func getAbilityLocalizedNames(name: String) async throws -> [String: String] {
        try await handleRemote(
            fetch: { try await apiClient.getAbility(name: name) },
            toModel: { $0.toLocalizedNames() }
        )
    }

    func searchPokemonNames(query: String) async throws -> [String] {
        let names: [String]
        if let cached = cacheStore.getPokemonNames(), !cached.isExpired {
            names = cached.data
        } else {
            let response = try await apiClient.getPokemonList(limit: pokemonListLimit, offset: 0)
            let fetched = response.toNames()
            cacheStore.savePokemonNames(fetched)
            names = fetched
        }
        return PokemonListResponse.filter(names: names, query: query)
    }
}
