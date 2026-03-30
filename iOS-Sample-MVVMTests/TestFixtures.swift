//
//  TestFixtures.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/30.
//

import Foundation
@testable import iOS_Sample_MVVM

/// テスト用のダミーデータとモック。
enum TestFixtures {
    static let fakePokemon = PokemonSummaryModel(
        name: "bulbasaur",
        url: "https://pokeapi.co/api/v2/pokemon/1/"
    )

    static let fakePokemonList = [fakePokemon]

    static let fakePokemonDetail = PokemonDetailModel(
        id: 1,
        name: "bulbasaur",
        height: 7,
        weight: 69,
        baseExperience: 64,
        types: ["grass", "poison"],
        abilities: [
            PokemonDetailModel.Ability(name: "overgrow", japaneseName: "しんりょく", isHidden: false),
            PokemonDetailModel.Ability(name: "chlorophyll", japaneseName: "ようりょくそ", isHidden: true),
        ],
        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
        stats: [
            PokemonDetailModel.Stat(name: "hp", value: 45),
            PokemonDetailModel.Stat(name: "attack", value: 49),
        ]
    )

    static let fakeSpecies = PokemonSpeciesModel(
        japaneseName: "フシギダネ",
        flavorText: "はっぱ",
        genus: "たねポケモン",
        eggGroups: ["monster", "plant"],
        genderRate: 1,
        captureRate: 45,
        habitat: nil,
        generation: "generation-i",
        evolutionChainUrl: "https://pokeapi.co/api/v2/evolution-chain/1/"
    )

    static let fakeFullDetail = PokemonFullDetailModel(
        detail: fakePokemonDetail,
        species: fakeSpecies,
        evolutionChain: []
    )
}

// MARK: - Mock Repositories

final class MockPokemonRepository: PokemonRepositoryProtocol {
    var getPokemonListResult: Result<[PokemonSummaryModel], Error> = .success([])
    var getPokemonDetailResult: Result<PokemonDetailModel, Error> = .success(TestFixtures.fakePokemonDetail)
    var getPokemonSpeciesResult: Result<PokemonSpeciesModel, Error> = .success(TestFixtures.fakeSpecies)
    var getEvolutionChainResult: Result<[EvolutionStageModel], Error> = .success([])
    var getAbilityLocalizedNamesResult: Result<[String: String], Error> = .success([:])
    var searchPokemonNamesResult: Result<[String], Error> = .success([])

    var getPokemonDetailCallCount = 0
    var lastForceRefresh = false

    func getPokemonList(offset _: Int, limit _: Int) async throws -> [PokemonSummaryModel] {
        try getPokemonListResult.get()
    }

    func getPokemonDetail(name _: String, forceRefresh: Bool) async throws -> PokemonDetailModel {
        getPokemonDetailCallCount += 1
        lastForceRefresh = forceRefresh
        return try getPokemonDetailResult.get()
    }

    func getPokemonSpecies(name _: String) async throws -> PokemonSpeciesModel {
        try getPokemonSpeciesResult.get()
    }

    func getEvolutionChain(url _: String) async throws -> [EvolutionStageModel] {
        try getEvolutionChainResult.get()
    }

    func getAbilityLocalizedNames(name _: String) async throws -> [String: String] {
        try getAbilityLocalizedNamesResult.get()
    }

    func searchPokemonNames(query _: String) async throws -> [String] {
        try searchPokemonNamesResult.get()
    }
}

final class MockFavoriteRepository: FavoriteRepositoryProtocol {
    var getFavoritesResult: Result<[FavoriteModel], Error> = .success([])
    var isFavoriteResult: Result<Bool, Error> = .success(false)
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var lastRemovedId: Int?

    func getFavorites() async throws -> [FavoriteModel] {
        try getFavoritesResult.get()
    }

    func isFavorite(id _: Int) async throws -> Bool {
        try isFavoriteResult.get()
    }

    func addFavorite(detail _: PokemonDetailModel) async throws {
        addFavoriteCalled = true
    }

    func removeFavorite(id: Int) async throws {
        removeFavoriteCalled = true
        lastRemovedId = id
    }
}
