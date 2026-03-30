//
//  PokemonRepositoryProtocol.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation

/// ポケモンデータへのアクセスを抽象化するリポジトリインターフェース。
protocol PokemonRepositoryProtocol {
    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonSummaryModel]
    func getPokemonDetail(name: String, forceRefresh: Bool) async throws -> PokemonDetailModel
    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesModel
    func getEvolutionChain(url: String) async throws -> [EvolutionStageModel]
    func getAbilityLocalizedNames(name: String) async throws -> [String: String]
    func searchPokemonNames(query: String) async throws -> [String]
}
