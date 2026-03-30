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
    private let apiClient: PokeAPIClient
    private var cachedNames: [String] = []
    private var namesCachedAt: Date?

    init(apiClient: PokeAPIClient) {
        self.apiClient = apiClient
    }

    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonSummaryModel] {
        let response = try await apiClient.getPokemonList(limit: limit, offset: offset)
        return response.results.map { PokemonSummaryModel(name: $0.name, url: $0.url) }
    }

    func getPokemonDetail(name: String, forceRefresh: Bool) async throws -> PokemonDetailModel {
        let response = try await apiClient.getPokemonDetail(name: name)
        return PokemonDetailMapper.toModel(from: response)
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesModel {
        let response = try await apiClient.getPokemonSpecies(name: name)
        return PokemonSpeciesMapper.toModel(from: response)
    }

    func getEvolutionChain(url: String) async throws -> [EvolutionStageModel] {
        let response = try await apiClient.getEvolutionChain(url: url)
        return EvolutionChainMapper.toModel(from: response)
    }

    func getAbilityLocalizedNames(name: String) async throws -> [String: String] {
        let response = try await apiClient.getAbility(name: name)
        return AbilityMapper.toModel(from: response)
    }

    func searchPokemonNames(query: String) async throws -> [String] {
        if cachedNames.isEmpty || CacheConfig.isExpired(cachedAt: namesCachedAt) {
            let response = try await apiClient.getPokemonList(limit: pokemonListLimit, offset: 0)
            cachedNames = response.results.map { $0.name }
            namesCachedAt = Date()
        }
        return cachedNames.filter { $0.localizedCaseInsensitiveContains(query.trimmingCharacters(in: .whitespaces)) }
    }
}
