//
//  PokemonRepositoryImplTests.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import XCTest
@testable import iOS_Sample_MVVM

final class PokemonRepositoryImplTests: XCTestCase {
    private var apiClient: MockPokeAPIClient!
    private var repository: PokemonRepositoryImpl!

    override func setUp() {
        apiClient = MockPokeAPIClient()
        repository = PokemonRepositoryImpl(apiClient: apiClient)
    }

    func test_ポケモン一覧を正しく取得する() async throws {
        apiClient.getPokemonListResult = .success(
            PokemonListResponse(results: [
                .init(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            ])
        )

        let result = try await repository.getPokemonList(offset: 0, limit: 20)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "bulbasaur")
    }

    func test_ポケモン詳細を正しく取得する() async throws {
        apiClient.getPokemonDetailResult = .success(Self.createDetailResponse())

        let result = try await repository.getPokemonDetail(name: "bulbasaur", forceRefresh: false)

        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertEqual(result.id, 1)
    }

    func test_URLErrorが発生した場合にnetworkエラーになる() async {
        apiClient.getPokemonDetailResult = .failure(URLError(.notConnectedToInternet))

        do {
            _ = try await repository.getPokemonDetail(name: "bulbasaur", forceRefresh: false)
            XCTFail("Expected error")
        } catch {
            guard case AppError.network = error else {
                XCTFail("Expected network error, got \(error)")
                return
            }
        }
    }

    func test_種族情報を正しく取得する() async throws {
        apiClient.getPokemonSpeciesResult = .success(Self.createSpeciesResponse())

        let result = try await repository.getPokemonSpecies(name: "bulbasaur")

        XCTAssertEqual(result.japaneseName, "フシギダネ")
    }

    func test_進化チェーンを正しく取得する() async throws {
        apiClient.getEvolutionChainResult = .success(
            EvolutionChainResponse(
                id: 1,
                chain: .init(
                    species: .init(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
                    evolvesTo: [],
                    evolutionDetails: []
                )
            )
        )

        let result = try await repository.getEvolutionChain(url: "url")

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "bulbasaur")
    }

    func test_特性のローカライズ名を正しく取得する() async throws {
        apiClient.getAbilityResult = .success(
            AbilityResponse(names: [
                .init(name: "しんりょく", language: NamedResource(name: "ja")),
                .init(name: "Overgrow", language: NamedResource(name: "en")),
            ])
        )

        let result = try await repository.getAbilityLocalizedNames(name: "overgrow")

        XCTAssertEqual(result["ja"], "しんりょく")
    }

    func test_キャッシュされた名前でポケモンを検索する() async throws {
        apiClient.getPokemonListResult = .success(
            PokemonListResponse(results: [
                .init(name: "bulbasaur", url: "url1"),
                .init(name: "charmander", url: "url2"),
                .init(name: "pikachu", url: "url3"),
            ])
        )

        let result = try await repository.searchPokemonNames(query: "char")

        XCTAssertEqual(result, ["charmander"])
    }

    // MARK: - Helpers

    private static func createDetailResponse() -> PokemonDetailResponse {
        PokemonDetailResponse(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: [.init(type: .init(name: "grass"))],
            abilities: [.init(ability: .init(name: "overgrow"), isHidden: false)],
            sprites: .init(other: .init(officialArtwork: .init(frontDefault: "url"))),
            stats: [.init(baseStat: 45, stat: .init(name: "hp"))]
        )
    }

    private static func createSpeciesResponse() -> PokemonSpeciesResponse {
        PokemonSpeciesResponse(
            names: [.init(name: "フシギダネ", language: NamedResource(name: "ja"))],
            flavorTextEntries: [.init(flavorText: "はっぱ", language: NamedResource(name: "ja"), version: NamedResource(name: "red"))],
            evolutionChain: .init(url: "url"),
            genera: [.init(genus: "たねポケモン", language: NamedResource(name: "ja"))],
            eggGroups: [NamedResource(name: "monster")],
            genderRate: 1,
            captureRate: 45,
            habitat: nil,
            generation: NamedResource(name: "generation-i")
        )
    }
}

// MARK: - Mock API Client

final class MockPokeAPIClient: PokeAPIClientProtocol {
    var getPokemonListResult: Result<PokemonListResponse, Error> = .success(PokemonListResponse(results: []))
    var getPokemonDetailResult: Result<PokemonDetailResponse, Error>!
    var getPokemonSpeciesResult: Result<PokemonSpeciesResponse, Error>!
    var getEvolutionChainResult: Result<EvolutionChainResponse, Error>!
    var getAbilityResult: Result<AbilityResponse, Error>!

    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        try getPokemonListResult.get()
    }

    func getPokemonDetail(name: String) async throws -> PokemonDetailResponse {
        try getPokemonDetailResult.get()
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpeciesResponse {
        try getPokemonSpeciesResult.get()
    }

    func getEvolutionChain(url: String) async throws -> EvolutionChainResponse {
        try getEvolutionChainResult.get()
    }

    func getAbility(name: String) async throws -> AbilityResponse {
        try getAbilityResult.get()
    }
}
